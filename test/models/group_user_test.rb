require 'test_helper'

class GroupUserTest < ActiveSupport::TestCase
  test "add user to group" do
    group_users = GroupUser.new({
      :user_id => 5,
      :group_id => 6
    })
    group_users.save!

    assert group_users.user_id === 5, 'new user ID match'
    assert group_users.group_id === 6, 'new group ID match'
  end

  test "group users match group ID" do
    users = User.get_users_by_group_id(1)

    assert users.count === 3, 'fixture user count matches'
    assert users[0].first_name?, 'fixture first name is set'
    assert users[0].last_name?, 'fixture last name is set'
  end

  test "groups match user match user ID" do
    groups = Group.get_groups_by_user_id(2)

    assert groups.count === 2, 'fixture group count matches'
    assert groups[0].group_name?, 'fixture group name is set'
  end

end
