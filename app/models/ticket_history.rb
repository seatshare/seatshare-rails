class TicketHistory < ActiveRecord::Base
  belongs_to :ticket

  validates :ticket_id, :group_id, :event_id, :user_id, :entry, :presence => true

  def entry_to_string
    entry = JSON.parse(self.entry)
    user = User.find(self.user_id)
    "#{user.full_name} #{entry['text']}"
  end

  def date_time
    self.created_at.strftime('%-m/%-d/%Y %-I:%M %P')
  end

  def ticket
    Ticket.find(self.ticket_id)
  end

  def user
    User.find(self.user_id)
  end

  def event
    Event.find(self.event_id)
  end

  def group
    Group.find(self.group_id)
  end

end