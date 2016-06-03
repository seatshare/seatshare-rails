##
# Group User model
class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  ##
  # New group user object
  # - attributes: attributes for object
  def initialize(attributes = {})
    attr_with_defaults = {
      daily_reminder: true,
      weekly_reminder: true,
      mine_only: false
    }.merge(attributes)
    super(attr_with_defaults)
  end

  ##
  # Display name for group user record
  def display_name
    "#{user} - #{group}"
  end
end
