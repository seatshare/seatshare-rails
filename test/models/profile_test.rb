require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  
  test "convert phone number to E.164 format" do
    user = User.find(1)
    assert_equal "+14108675309", user.profile.mobile_e164
  end

end
