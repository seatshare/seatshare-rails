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

  scope :order_by_date, -> { order('start_time ASC') }
  scope :order_by_seat, -> { order_by_seat }

  def display_name
    [section, row, seat].join(' ').strip
  end

  def assigned
    User.find_by_id(user_id)
  end

  def available?
    user_id == 0
  end

  def assigned?
    user_id > 0
  end

  private

  def seat_location?
    empty_error = 'Ticket must have a section, row or seat'
    errors[:base] << (empty_error) if display_name.blank?
  end

  def self.order_by_seat
    order('section ASC').order('row ASC').order('seat ASC')
  end
end
