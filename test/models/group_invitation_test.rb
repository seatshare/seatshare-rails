require 'test_helper'

##
# Group Invitation test
class GroupInvitationTest < ActiveSupport::TestCase
  test 'new group invitation has attributes' do
    invitation = GroupInvitation.new(
      user_id: 1,
      email: 'someguy@example.com',
      group_id: 1
    )
    invitation.save!

    refute_empty invitation.invitation_code
    assert_equal invitation.email, 'someguy@example.com'
    assert_equal invitation.group_id, 1
    assert_equal invitation.user_id, 1
  end

  test 'use invitation' do
    invitation = GroupInvitation.get_by_invitation_code('ABCDEFG123')

    assert invitation.status, 'is a valid invitation code'
    assert_equal invitation.email, 'bob@example.com', 'has an email address'
    assert_equal invitation.user_id, 4, 'invitation attached to an ID'

    invitation.use_invitation
    invitation = GroupInvitation.get_by_invitation_code('ABCDEFG123')

    refute invitation.status, 'invitation was marked as used'
  end
end
