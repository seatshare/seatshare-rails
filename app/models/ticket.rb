class Ticket < ActiveRecord::Base
  has_many :users
  has_many :entities, through: :events
  has_many :ticket_files
  has_many :ticket_histories
  belongs_to :event
  
  validates :group_id, :event_id, :owner_id, :user_id, :presence => true
  validates :cost, :numericality => { :greater_than_or_equal_to => 0 }

  def owner
    User.find_by_id(self.owner_id)
  end

  def assigned
    User.find_by_id(self.user_id)
  end

  def alias
    UserAlias.find_by_id(self.alias_id)
  end

  def section_row_seat
    [self.section, self.row, self.seat].join(" ").strip
  end

  def is_available?
    !!(self.user_id === 0)
  end

  def is_assigned?
    !!(self.user_id > 0)
  end

end
