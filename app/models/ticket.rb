##
# Ticket model
class Ticket < ActiveRecord::Base
  has_many :ticket_files
  has_many :ticket_histories
  belongs_to :event
  belongs_to :group, class_name: 'Group'
  belongs_to :user, class_name: 'User'
  belongs_to :owner, class_name: 'User'
  belongs_to :alias, class_name: 'UserAlias'

  validate :seat_location?
  validates :group_id, :event_id, :owner_id, :user_id, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }

  scope :by_date, -> { joins(:event).order('events.start_time ASC') }
  scope :by_seat, -> { order(:section, :row, :seat) }

  ##
  # Display name for ticket
  def display_name
    [section, row, seat].join(' ').strip
  end

  ##
  # Relation of assigned user
  def assigned
    User.find_by_id(user_id)
  end

  ##
  # True if ticket is available
  def available?
    user_id == 0
  end

  ##
  # True if ticket is assigned
  def assigned?
    user_id > 0
  end

  ##
  # Remove ticket assignment
  def unassign
    self.user_id = 0
    self.alias_id = 0
    self.save!
  end

  ##
  # Can Edit
  def can_edit?(user)
    return true if user_id == user.id
    return true if owner_id == user.id
    false
  end

  ##
  # Log a ticket history record
  # - ticket: Ticket object
  # - action: string of action
  def self.log_ticket_history(ticket = nil, action = nil, actor)
    user = User.find_by_id(ticket.user_id)
    if !user.nil?
      user_record = user.attributes
    else
      user_record = nil
    end
    ticket_history = TicketHistory.new(
      event_id: ticket.event_id,
      user_id: actor.id,
      ticket_id: ticket.id,
      group_id: ticket.group_id,
      entry: JSON.generate(
        text: action, user: user_record, ticket: ticket.attributes
      )
    )
    ticket_history.save
  end

  private

  ##
  # Validate that ticket has a seat location
  def seat_location?
    empty_error = 'Ticket must have a section, row or seat'
    errors[:base] << (empty_error) if display_name.blank?
  end
end
