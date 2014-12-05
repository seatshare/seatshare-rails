##
# Subscription model
class Subscription < ActiveRecord::Base
  belongs_to :group
end
