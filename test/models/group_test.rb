require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  test "new group has attributes" do
    group = Group.new({
      :group_name => 'Another Sportsball Group',
      :creator_id => 5,
      :entity_id => 6
    })
    group.save!

    assert group.group_name === 'Another Sportsball Group', 'new group name matches'
    assert group.creator_id === 5, 'new group creator ID matches'
    assert group.invitation_code.length === 10, 'new group has valid invitation code'
  end

  test "fixture group has attributes" do
    group = Group.find(1)

    assert group.group_name === 'Geeks Watching Hockey', 'group name matches fixture'
    assert group.entity_id === 1, 'group entity ID matches fixture'
    assert group.entity.entity_name === 'Nashville Predators', 'entity name matches fixture'
    assert group.members.count === 3, 'group member count matches'
  end

  test "get group by ticket ID" do
    group = Group.get_by_ticket_id(1)

    assert group.id === 1, 'fixture group ID matches'
    assert group.group_name === 'Geeks Watching Hockey', 'fixture group name matches'
  end

  test "gets groups by user ID" do
    groups = Group.get_groups_by_user_id(2)

    assert groups.count === 2, 'fixture group count matches'
  end

  test "check if member" do
    user = User.find(1)
    group = Group.find(3)

    assert group.is_member(user) === false, "fixture user is not a member"
    assert group.is_admin(user) === false, "fixture user is not an admin"
  end

  test "check if admin" do
    user = User.find(1)
    group = Group.find(1)

    assert group.is_member(user) === true, "fixture user is a member"
    assert group.is_admin(user) === true, "fixture user is an admin"
  end

  test "join a group" do
    user = User.find(4)
    group = Group.find(2)

    assert group.is_member(user) === false, 'user is not yet a member'
    assert group.is_admin(user) === false, 'user is not an admin'

    group_user = group.join_group(user)

    assert group_user.user_id === 4, 'user ID matches'
    assert group_user.group_id === 2, 'group ID matches'
    assert group_user.role === 'member', 'role matches'

    assert group.is_member(user) === true, 'user is a member'
    assert group.is_admin(user) === false, 'user is not an admin'
  end

  test "join a group as an admin" do
    user = User.find(4)
    group = Group.find(2)

    assert group.is_member(user) === false, 'user is not yet a member'
    assert group.is_admin(user) === false, 'user is not yet an admin'

    group_user = group.join_group(user, 'admin')

    assert group_user.user_id === 4, 'user ID matches'
    assert group_user.group_id === 2, 'group ID matches'
    assert group_user.role === 'admin', 'role matches'

    assert group.is_member(user) === true, 'user is a member'
    assert group.is_admin(user) === true, 'user is an admin'
  end

end
