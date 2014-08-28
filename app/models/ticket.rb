class Ticket < ActiveRecord::Base
  has_many :ticket_files
  has_many :ticket_histories
  belongs_to :event
  belongs_to :group, :class_name => 'Group'
  belongs_to :user, :class_name => 'User'
  belongs_to :owner, :class_name => 'User'
  belongs_to :alias, :class_name => 'UserAlias'
  
  validates :group_id, :event_id, :owner_id, :user_id, :presence => true
  validates :cost, :numericality => { :greater_than_or_equal_to => 0 }

  scope :order_by_seat, -> { order('section ASC').order('row ASC').order('seat ASC') }

  def display_name
    [self.section, self.row, self.seat].join(" ").strip
  end

  def assigned
    User.find_by_id(self.user_id)
  end

  def is_available?
    !!(self.user_id === 0)
  end

  def is_assigned?
    !!(self.user_id > 0)
  end

end
