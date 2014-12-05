##
# Profile model
class Profile < ActiveRecord::Base
  has_one :user

  ##
  # Format mobile phone number in `+11235551234` format
  def mobile_e164
    GlobalPhone.normalize(mobile)
  end
end
