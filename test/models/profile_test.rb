require 'test_helper'

##
# Profile test
class ProfileTest < ActiveSupport::TestCase
  test 'convert phone number to E.164 format' do
    user = User.find(1)
    assert_equal '+14108675309', user.profile.mobile_e164
  end

  test 'uses markdown for bio' do
    user = User.find(1)
    user.profile.bio = "*I'm a teapot*"

    assert_equal user.profile.bio_md, "<p><em>I&#39;m a teapot</em></p>\n"

    user.profile.bio = 'http://google.com'

    assert_equal(
      user.profile.bio_md,
      "<p><a href=\"http://google.com\">http://google.com</a></p>\n"
    )
  end
end
