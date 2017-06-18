require 'test_helper'

##
# User test
class UserTest < ActiveSupport::TestCase
  test 'create new user' do
    user = User.new(
      first_name: 'Randy',
      last_name: 'Phillips',
      email: 'randy23@example.net',
      password: 'somethingpasswordy'
    )
    user.save!

    assert user.first_name == 'Randy', 'new user first name matches'
    assert user.last_name == 'Phillips', 'new user last name matches'
    assert user.email == 'randy23@example.net', 'new user email matches'
  end

  test 'get user from fixture' do
    user = User.find(1)

    assert user.first_name == 'Jim', 'fixture first name matches'
    assert user.last_name == 'Stone', 'fixture last name matches'
    assert user.email == 'stonej@example.net', 'fixture email matches'
    assert user.bio == 'A simple kind of man.', 'fixture bio matches'
    assert user.location == 'Some Town, TX', 'fixture location matches'
    assert user.mobile == '141-086-75309', 'fixture mobile matches'
    assert user.sms_notify == true, 'fixture sms_notify matches'
  end

  test 'get full name of user' do
    user = User.find(2)

    assert user.display_name == 'Jill Smith'
  end

  test 'group users match group ID' do
    users = Group.find(2).members

    assert users.count == 2, 'fixture user count matches'
    assert users[0].first_name?, 'fixture first name is set'
    assert users[0].last_name?, 'fixture last name is set'
  end

  test 'user can view?' do
    user1 = User.find(1)
    user2 = User.find(2)
    user3 = User.find(3)
    user4 = User.find(4)
    user8 = User.find(8)

    assert user1.user_can_view?(user2) == true
    assert user2.user_can_view?(user3) == true
    assert user3.user_can_view?(user4) == false
    assert user4.user_can_view?(user2) == false
    assert user8.user_can_view?(user8) == true
  end

  test 'convert phone number to E.164 format' do
    user = User.find(1)
    assert_equal '+14108675309', user.mobile_e164
  end

  test 'uses markdown for bio' do
    user = User.find(1)

    user.bio = "*I'm a teapot*"
    assert_equal user.bio_md, "<p><em>I&#39;m a teapot</em></p>\n"

    user.bio = 'http://google.com'
    assert_equal(
      "<p><a href=\"http://google.com\">http://google.com</a></p>\n",
      user.bio_md
    )
  end

  test 'included a script tag in bio' do
    user = User.find(1)

    user.bio = "<script>window.alert('evil')</script>"
    assert_equal "<p>window.alert(&#39;evil&#39;)</p>\n", user.bio_md
  end
end
