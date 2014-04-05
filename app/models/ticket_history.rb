class TicketHistory < ActiveRecord::Base
  belongs_to :tickets

  validates :ticket_id, :group_id, :event_id, :user_id, :entry, :presence => true
end
