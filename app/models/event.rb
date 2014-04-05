class Event < ActiveRecord::Base
	belongs_to :entities
  has_many :tickets

  validates :entity_id, :event_name, :start_time, :presence => true

  def initialize(attributes={})
    attr_with_defaults = {
      :date_tba => 0,
      :time_tba => 0,
      :description => ''
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def self.get_by_group_id(group_id=nil)
    entity = Entity.get_by_group_id(group_id)
    events = Event.where("entity_id = #{entity.id}")
    return events
  end

  def self.get_by_ticket_id(ticket_id=nil)
    ticket = Ticket.find(ticket_id)
    event = Event.find(ticket.event_id)
    return event
  end

end
