class UserReminder < ActiveRecord::Base
  has_many :users
  has_many :reminders

  validates :group_id, :user_id, :reminder_type_id, :presence => true
end
