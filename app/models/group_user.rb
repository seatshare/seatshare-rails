##
# Group User model
class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  ##
  # New group user object
  # - attributes: attributes for object
  def initialize(attributes = {})
    attr_with_defaults = {
      daily_reminder: 1,
      weekly_reminder: 1,
      mine_only: 0
    }.merge(attributes)
    super(attr_with_defaults)
  end

  ##
  # Display name for group user record
  def display_name
    "#{user} - #{group}"
  end
end
