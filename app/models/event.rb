##
# Event model
class Event < ActiveRecord::Base
  belongs_to :entity
  has_many :tickets
  has_many :groups, through: :entity

  validates :entity_id, :event_name, :start_time, presence: true
  before_save :clean_import_key

  scope :order_by_date, -> { order('start_time ASC') }
  scope :future, -> { where("start_time > '#{Time.now}'") }
  scope :past, -> { where("start_time < '#{Time.now}'") }
  scope :next_seven_days, -> { next_seven_days }
  scope :today, -> { today }

  @ticket_stats = nil

  ##
  # New event object
  # - attributes: attributes for object
  def initialize(attributes = {})
    attr_with_defaults = {
      date_tba: 0,
      time_tba: 0,
      description: '',
      import_key: generate_import_key(attributes)
    }.merge(attributes)
    super(attr_with_defaults)
  end

  ##
  # Display name for event
  def display_name
    "#{entity.entity_name}: #{event_name} - #{date_time}"
  end

  ##
  # Override the default tickets relationship
  # - group: Group object
  def tickets(group = nil)
    if group.nil?
      Ticket.where("event_id = #{id}")
    else
      Ticket.where("event_id = #{id} AND group_id = #{group.id}")
    end
  end

  ##
  # Generate ticket stats for the group/user
  # - group: Group object
  # - user: User object
  def ticket_stats(group = nil, user = nil)
    fail 'NoGroupSpecified' if group.nil?
    fail 'NoUserSpecified' if user.nil?

    tickets = self.tickets(group)

    stats = { available: 0, total: 0, held: 0 }
    tickets.each do |ticket|
      stats[:available] += 1 if ticket.user_id == 0
      stats[:held] += 1 if ticket.user_id == user.id
      stats[:total] += 1
    end

    if stats[:total] > 0
      stats[:percent_full] = (
        (stats[:total].to_f - stats[:available].to_f) / stats[:total].to_f
      ) * 100
    else
      stats[:percent_full] = 0
    end

    stats
  end

  ##
  # Show the date/time of the start of the event based on TBA settings
  def date_time
    out = ''
    out += start_time.strftime('%A, %B %-d, %Y') if date_tba == 0
    if time_tba == 0
      out += ' - '
      out += start_time.strftime('%-I:%M %P %Z')
    end
    out
  end

  ##
  # Description as Markdown
  def description_md
    GitHub::Markdown.render(description)
  end

  ##
  # Create a new event based on object passed from SODA importer
  # - row: hash passed from importer
  def self.import(row = nil)
    event = find_by_import_key(row[:event_key]) || new

    event.entity_id = row[:entity_id]
    event.event_name = "#{row[:away_team]} vs. #{row[:home_team]}"
    event.start_time = row[:start_date_time]
    event.import_key = row[:event_key]
    if !row[:time_certainty].blank? && row[:time_certainty] != 'certain'
      event.time_tba = 1
    end
    event.save!

    event
  end

  ##
  # User has tickets?
  def user_has_ticket?(user)
    tickets = Ticket.where("event_id = #{id} AND user_id = #{user.id}")
    return false if tickets.empty?
    true
  end

  private

  ##
  # Generate an import key for new events
  # - attrs: attributes for object
  def generate_import_key(attrs)
    "#{attrs[:entity_id]}: #{attrs[:event_name]} #{attrs[:start_time]}"
      .parameterize
  end

  ##
  # Run import key generator if not set
  def clean_import_key
    self.import_key = generate_import_key(self) if import_key.blank?
  end

  ##
  # Next Seven Days
  def self.next_seven_days
    where(
      "start_time >= '#{Date.today.beginning_of_day.utc}'"\
      " AND start_time <= '#{Date.today.end_of_day.utc + 6.days}'"
    )
  end

  ##
  # Today
  def self.today
    where(
      "start_time >= '#{Date.today.beginning_of_day.utc}'"\
      " AND start_time <= '#{Date.today.end_of_day.utc}'"
    )
  end
end
