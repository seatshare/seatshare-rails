class Reminder < ActiveRecord::Base
  belongs_to :users
  has_many :groups
end
