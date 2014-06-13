class Reminder < ActiveRecord::Base
  belongs_to :user
  has_many :groups
end
