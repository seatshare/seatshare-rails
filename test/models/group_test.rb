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

    assert_equal 'Another Sportsball Group', group.group_name, 'name matches'
    assert_equal 5, group.creator_id, 'new group creator ID matches'
    assert_equal 10, group.invitation_code.length, 'valid invitation code'
  end

  test 'fixture group has attributes' do
    group = Group.find(1)

    assert_equal 'Geeks Watching Hockey', group.group_name, 'name matches'
    assert_equal 1, group.entity_id, 'group entity ID matches fixture'
    assert_equal 'Nashville Predators', group.entity.entity_name, 'name matches'
    assert_equal 3, group.members.count, 'group member count matches'
  end

  test 'get group by ticket ID' do
    group = Ticket.find(1).group

    assert_equal 1, group.id, 'fixture group ID matches'
    assert_equal 'Geeks Watching Hockey', group.group_name, 'group name matches'
  end

  test 'gets groups by user ID' do
    groups = User.find(2).groups

    assert_equal groups.count, 2, 'fixture group count matches'
  end

  test 'check if member' do
    user = User.find(1)
    group = Group.find(3)

    refute group.member?(user), 'fixture user is not a member'
    refute group.admin?(user), 'fixture user is not an admin'
  end

  test 'check if admin' do
    user = User.find(1)
    group = Group.find(1)

    assert group.member?(user), 'fixture user is a member'
    assert group.admin?(user), 'fixture user is an admin'
  end

  test 'join a group' do
    user = User.find(4)
    group = Group.find(2)

    refute group.member?(user), 'user is not yet a member'
    refute group.admin?(user), 'user is not an admin'

    membership = group.join_group(user)

    assert_equal 4, membership.user_id, 'user ID matches'
    assert_equal 2, membership.group_id, 'group ID matches'
    assert_equal 'member', membership.role, 'role matches'

    assert group.member?(user), 'user is a member'
    refute group.admin?(user), 'user is not an admin'
  end

  test 'join a group as an admin' do
    user = User.find(4)
    group = Group.find(2)

    refute group.member?(user), 'user is not yet a member'
    refute group.admin?(user), 'user is not yet an admin'

    membership = group.join_group(user, 'admin')

    assert_equal 4, membership.user_id, 'user ID matches'
    assert_equal 2, membership.group_id, 'group ID matches'
    assert_equal 'admin', membership.role, 'role matches'

    assert group.member?(user), 'user is a member'
    assert group.admin?(user), 'user is an admin'
  end

  test 'gets correct list of administrators' do
    group = Group.find(2)

    assert_equal 1, group.administrators.count
    assert_equal 'Rick', group.administrators.first.first_name
    assert_equal 'Taylor', group.administrators.first.last_name
  end

  test 'leave a group' do
    user = User.find(2)
    group = Group.find(1)

    assert group.member?(user), 'user is a member'
    refute group.admin?(user), 'user is not an admin'

    group.leave_group(user)

    refute group.member?(user), 'user is not a member'
    refute group.admin?(user), 'user is not an admin'
  end

  test 'leave a group as an admin' do
    user = User.find(1)
    group = Group.find(1)

    assert group.member?(user), 'user is a member'
    assert group.admin?(user), 'user is an admin'

    assert_raises RuntimeError do
      group.leave_group(user)
    end

    assert group.member?(user), 'user is still a member'
    assert group.admin?(user), 'user is still an admin'
  end

  test 'deactivate a group as an admin' do
    user = User.find(1)
    group = Group.find(1)

    assert group.member?(user), 'user is a member'
    assert group.admin?(user), 'user is an admin'

    group.deactivate

    refute group.status, 'group is inactive'
    assert group.member?(user), 'user is still a member'
    assert group.admin?(user), 'user is still an admin'
  end
end
