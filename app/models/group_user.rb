class GroupUser < ActiveRecord::Base
  belongs_to :groups
  belongs_to :users

  def initialize(attributes={})
    attr_with_defaults = {
      :daily_reminder => 1,
      :weekly_reminder => 1
    }.merge(attributes)
    super(attr_with_defaults)
  end

end
