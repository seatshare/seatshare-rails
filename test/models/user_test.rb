require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "create new user" do
    user = User.new({
      :first_name => 'Randy',
      :last_name => 'Phillips',
      :email => 'randy23@example.net',
      :password => 'somethingpasswordy'
    })
    user.save!

    assert user.first_name === 'Randy', 'new user first name matches'
    assert user.last_name === 'Phillips', 'new user last name matches'
    assert user.email === 'randy23@example.net', 'new user email matches'
  end

  test "get user from fixture" do
    user = User.find(1)

    assert user.first_name === 'Jim', 'fixture first name matches'
    assert user.last_name === 'Stone', 'fixture last name matches'
    assert user.email === 'stonej@example.net', 'fixture email matches'
  end

  test "get full name of user" do
    user = User.find(2)

    assert user.full_name === 'Jill Smith'
  end

  test "group users match group ID" do
    users = User.get_users_by_group_id(2)

    assert users.count === 2, 'fixture user count matches'
    assert users[0].first_name?, 'fixture first name is set'
    assert users[0].last_name?, 'fixture last name is set'
  end

end
