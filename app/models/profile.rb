class Profile < ActiveRecord::Base
  has_one :user

  def mobile_e164
    GlobalPhone.normalize(mobile)
  end

end
