class UserAlias < ActiveRecord::Base
  belongs_to :users

  validates :first_name, :last_name, :user_id, :presence => true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
