class Event < ActiveRecord::Base
	belongs_to :entity
  has_many :tickets

  validates :entity_id, :event_name, :start_time, :presence => true

  @ticket_stats = nil

  def initialize(attributes={})
    attr_with_defaults = {
      :date_tba => 0,
      :time_tba => 0,
      :description => ''
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def display_name
    "#{entity.entity_name}: #{event_name} #{date_time}"
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
      railse "NoUserSpecified"
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
    Time.zone = 'Central Time (US & Canada)' 
    out = ''
    if self.date_tba === 0
      out += self.start_time.strftime('%A, %B %-d, %Y')
    end
    if self.time_tba === 0
      out += ' - '
      out += self.start_time.strftime('%-I:%M %P')
    end
    return out
  end

  def self.get_by_group_id(group_id=nil)
    entity = Entity.get_by_group_id(group_id)
    Event.where("entity_id = #{entity.id}")
  end

  def self.get_by_ticket_id(ticket_id=nil)
    ticket = Ticket.find(ticket_id)
    Event.find(ticket.event_id)
  end

end
