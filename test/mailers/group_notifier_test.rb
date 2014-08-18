require 'test_helper'

class GroupNotifierTest < ActionMailer::TestCase
  test "send group invitation" do
    invite = GroupInvitation.find(1)

    email = GroupNotifier.create_invite(invite).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@myseatshare.com'], email.from
    assert_equal ['bob@example.com'], email.to
    assert_equal 'You have been invited to join Geeks Watching Hockey', email.subject
    assert_includes email.body.to_s, '<title>You have been invited to join Geeks Watching Hockey</title>'
    assert_includes email.body.to_s, '<a href="http://localhost:3000/register?invite_code=ABCDEFG123">Use Invitation ABCDEFG123</a>'
    assert_includes email.body.to_s, 'Sarah Becker has invited you to join our <strong>Nashville Predators</strong> group on <a href="http://localhost:3000/">SeatShare</a>, a service that helps manage our season tickets.'
  end
end
