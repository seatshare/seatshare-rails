##
# Event model
class Event < ActiveRecord::Base
  belongs_to :entity
  has_many :tickets
  has_many :groups, through: :entity

  validates :entity_id, :event_name, :start_time, presence: true
  before_save :clean_import_key

  scope :by_date, -> { order('start_time ASC') }
  scope :future, -> { where('start_time > ?', Time.zone.now) }
  scope :past, -> { where('start_time < ?', Time.zone.now) }
  scope :next_seven_days, -> { next_seven_days }
  scope :today, -> { today }
  scope :confirmed, -> { where('date_tba = 0') }

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
      Ticket.where(event_id: id)
    else
      Ticket.where(event_id: id, group_id: group.id)
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
  # Show only the time of the event based on TBA settings
  def time
    out = ''
    out += start_time.strftime('%-I:%M %P %Z') if time_tba == 0
    out
  end

  ##
  # Description as Markdown
  def description_md
    GitHub::Markdown.render(description)
  end

  ##
  # Create a new event from given hash
  # - row: hash passed from importer
  # - overwrite: whether to overwrite the title and description
  # - allow_duplicate: whether to allow duplicate at same time slot
  def self.import(hash = nil, overwrite = false, allow_duplicate = false)
    event = find_by_import_key(hash[:import_key]) || new
    event.entity_id = hash[:entity_id]
    event.event_name = hash[:event_name]
    if overwrite || event.new_record?
      # Attributes to overwrite (description)
      event.description = hash[:description]
    end
    event.start_time = hash[:start_time]
    event.import_key = hash[:import_key]
    event.date_tba = hash[:date_tba] || 0
    event.time_tba = hash[:time_tba] || 0

    if event.new_record? && !allow_duplicate
      collisions = Event.where(
        start_time: hash[:start_time], entity_id: event.entity_id
      )
      return collisions.first if collisions.size > 0
    end
    event.save!
    event
  end

  ##
  # Is SeatGeek?
  def seatgeek?
    import_key.include? 'api.seatgeek.com'
  end

  ##
  # SeatGeek Data
  def seatgeek_data
    fail 'Not a SeatGeek event' unless seatgeek?
    params = Rack::Utils.parse_query URI(import_key).query
    SeatGeek::Connection.protocol = :https
    response = SeatGeek::Connection.events(params)
    return false if response['events'].nil? || response['events'].count == 0
    response['events'].first
  end

  ##
  # User has tickets?
  def user_has_ticket?(user)
    tickets = Ticket.where(event_id: id, user_id: user.id)
    return false if tickets.empty?
    true
  end

  ##
  # To ICS
  def to_ics(event_link = nil)
    event = Icalendar::Event.new
    if time_tba == 0
      event.dtstart = start_time
      event.dtend = start_time + 3.hours
    else
      event.dtstart = start_time.to_date
    end
    event.summary = event_name
    event.description = description
    event.location = ''
    event.ip_class = 'PUBLIC'
    event.created = created_at
    event.last_modified = updated_at
    event.uid = import_key
    event.url = event_link unless event_link.nil?
    event
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
      'start_time >= ? AND start_time <= ?',
      Time.zone.today.beginning_of_day.utc,
      Time.zone.today.end_of_day.utc + 6.days
    )
  end

  ##
  # Today
  def self.today
    where(
      'start_time >= ? AND start_time <= ?',
      Time.zone.today.beginning_of_day.utc,
      Time.zone.today.end_of_day.utc
    )
  end
end
