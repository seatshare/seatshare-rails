require 'test_helper'

##
# Group test
class GroupTest < ActiveSupport::TestCase
  test 'new group has attributes' do
    group = Group.new(
      group_name: 'Another Sportsball Group',
      creator_id: 5,
      entity_id: 6
    )
    group.save!

    assert(
      group.group_name == 'Another Sportsball Group',
      'new group name matches'
    )
    assert group.creator_id == 5, 'new group creator ID matches'
    assert(
      group.invitation_code.length == 10,
      'new group has valid invitation code'
    )
  end

  test 'fixture group has attributes' do
    group = Group.find(1)

    assert(
      group.group_name == 'Geeks Watching Hockey',
      'group name matches fixture'
    )
    assert group.entity_id == 1, 'group entity ID matches fixture'
    assert(
      group.entity.entity_name == 'Nashville Predators',
      'entity name matches fixture'
    )
    assert group.users.count == 3, 'group member count matches'
  end

  test 'get group by ticket ID' do
    group = Ticket.find(1).group

    assert group.id == 1, 'fixture group ID matches'
    assert(
      group.group_name == 'Geeks Watching Hockey',
      'fixture group name matches'
    )
  end

  test 'gets groups by user ID' do
    groups = User.find(2).groups

    assert groups.count == 2, 'fixture group count matches'
  end

  test 'check if member' do
    user = User.find(1)
    group = Group.find(3)

    assert group.member?(user) == false, 'fixture user is not a member'
    assert group.admin?(user) == false, 'fixture user is not an admin'
  end

  test 'check if admin' do
    user = User.find(1)
    group = Group.find(1)

    assert group.member?(user) == true, 'fixture user is a member'
    assert group.admin?(user) == true, 'fixture user is an admin'
  end

  test 'join a group' do
    user = User.find(4)
    group = Group.find(2)

    assert group.member?(user) == false, 'user is not yet a member'
    assert group.admin?(user) == false, 'user is not an admin'

    group_user = group.join_group(user)

    assert group_user.user_id == 4, 'user ID matches'
    assert group_user.group_id == 2, 'group ID matches'
    assert group_user.role == 'member', 'role matches'

    assert group.member?(user) == true, 'user is a member'
    assert group.admin?(user) == false, 'user is not an admin'
  end

  test 'join a group as an admin' do
    user = User.find(4)
    group = Group.find(2)

    assert group.member?(user) == false, 'user is not yet a member'
    assert group.admin?(user) == false, 'user is not yet an admin'

    group_user = group.join_group(user, 'admin')

    assert group_user.user_id == 4, 'user ID matches'
    assert group_user.group_id == 2, 'group ID matches'
    assert group_user.role == 'admin', 'role matches'

    assert group.member?(user) == true, 'user is a member'
    assert group.admin?(user) == true, 'user is an admin'
  end

  test 'gets correct list of administrators' do
    group = Group.find(2)

    assert group.administrators.count == 1
    assert group.administrators.first.first_name == 'Rick'
    assert group.administrators.first.last_name == 'Taylor'
  end

  test 'leave a group' do
    user = User.find(2)
    group = Group.find(1)

    assert group.member?(user) == true, 'user is a member'
    assert group.admin?(user) == false, 'user is not an admin'

    group.leave_group(user)

    assert group.member?(user) == false, 'user is not a member'
    assert group.admin?(user) == false, 'user is not an admin'
  end

  test 'leave a group as an admin' do
    user = User.find(1)
    group = Group.find(1)

    assert group.member?(user) == true, 'user is a member'
    assert group.admin?(user) == true, 'user is an admin'

    assert_raises RuntimeError do
      group.leave_group(user)
    end

    assert group.member?(user) == true, 'user is still a member'
    assert group.admin?(user) == true, 'user is still an admin'
  end

  test 'deactivate a group as an admin' do
    user = User.find(1)
    group = Group.find(1)

    assert group.member?(user) == true, 'user is a member'
    assert group.admin?(user) == true, 'user is an admin'

    assert_raises RuntimeError do
      group.deactivate
    end

    assert group.status == 0, 'group is inactive'
    assert group.member?(user) == true, 'user is still a member'
    assert group.admin?(user) == true, 'user is still an admin'
  end
end
