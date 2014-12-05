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

    assert invitation.invitation_code != ''
    assert invitation.email == 'someguy@example.com'
    assert invitation.group_id == 1
    assert invitation.user_id == 1
  end

  test 'use invitation' do
    invitation = GroupInvitation.get_by_invitation_code('ABCDEFG123')

    assert invitation.status == 1, 'is a valid invitation code'
    assert(
      invitation.email == 'bob@example.com',
      'invitation has an email address'
    )
    assert invitation.user_id == 4, 'invitation attached to an ID'

    invitation.use_invitation
    invitation = GroupInvitation.get_by_invitation_code('ABCDEFG123')

    assert invitation.status == 0, 'invitation was marked as used'
  end
end
