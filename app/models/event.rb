class Event < ActiveRecord::Base
	belongs_to :entity
  has_many :tickets
  has_many :groups, through: :entity

  validates :entity_id, :event_name, :start_time, :presence => true
  before_save :clean_import_key

  scope :order_by_date, -> { order('start_time ASC') }

  @ticket_stats = nil

  def initialize(attributes={})
    attr_with_defaults = {
      :date_tba => 0,
      :time_tba => 0,
      :description => '',
      :import_key => generate_import_key(attributes)
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def display_name
    "#{entity.entity_name}: #{event_name} - #{date_time}"
  end

  def tickets(group=nil)
    if group.nil?
      Ticket.where("event_id = #{self.id}")
    else
      Ticket.where("event_id = #{self.id} AND group_id = #{group.id}")      
    end
  end

  def ticket_stats(group=nil, user=nil)
    if group.nil?
      raise "NoGroupSpecified"
    end
    if user.nil?
      raise "NoUserSpecified"
    end

    tickets = self.tickets(group)

    stats = {:available => 0, :total => 0, :held => 0}
    for ticket in tickets do
      if ticket.user_id === 0
        stats[:available] += 1
      end
      if ticket.user_id === user.id
        stats[:held] += 1
      end
      stats[:total] += 1
    end

    if stats[:total] > 0
      stats[:percent_full] = ((stats[:total].to_f - stats[:available].to_f)/stats[:total].to_f) * 100
    else
      stats[:percent_full] = 0
    end

    return stats
  end

  def date_time
    out = ''
    if self.date_tba === 0
      out += self.start_time.strftime('%A, %B %-d, %Y')
    end
    if self.time_tba === 0
      out += ' - '
      out += self.start_time.strftime('%-I:%M %P %Z')
    end
    return out
  end

  def self.import(row=nil)
    event = find_by_import_key(row[:event_key])
    if event.nil?
      event = new
    end

    event.entity_id = row[:entity_id]
    event.event_name = "#{row[:away_team]} vs. #{row[:home_team]}"
    event.start_time = row[:start_date_time]
    event.import_key = row[:event_key]
    if !row[:time_certainty].blank? && row[:time_certainty] != 'certain'
      event.time_tba = 1
    end
    event.save!

    return event
  end

  private

  def generate_import_key(attributes)
    "#{attributes[:entity_id]}: #{attributes[:event_name]} #{attributes[:start_time]}".parameterize
  end

  def clean_import_key
    if self.import_key.blank?
      self.import_key = generate_import_key(self)
    end
  end

end
