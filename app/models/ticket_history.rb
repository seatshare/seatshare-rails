class TicketHistory < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  belongs_to :event
  belongs_to :group

  validates :ticket_id, :group_id, :event_id, :user_id, :entry, presence: true

  def display_name
    entry = JSON.parse(self.entry)
    user = User.find(user_id)
    "#{user.display_name} #{entry['text']}"
  end

  def date_time
    created_at.strftime('%-m/%-d/%Y %-I:%M %P')
  end
end
