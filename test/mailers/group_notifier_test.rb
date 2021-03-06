require 'test_helper'

##
# Group Notifier test
class GroupNotifierTest < ActionMailer::TestCase
  test 'send group invitation' do
    invite = GroupInvitation.find(1)

    email = GroupNotifier.create_invite(invite).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [ENV['SEATSHARE_EMAIL_FROM']], email.from
    assert_equal ['sarahb@example.org'], email.reply_to
    assert_equal ['bob@example.com'], email.to
    assert_equal(
      'You have been invited to join Geeks Watching Hockey',
      email.subject
    )
    assert_includes(
      email.html_part.to_s,
      '<title>You have been invited to join Geeks Watching Hockey</title>'
    )
    assert_includes(
      email.html_part.to_s,
      'Use Invitation ABCDEFG123'
    )
    assert_includes(
      email.html_part.to_s,
      'href="http://localhost:3000/register/invite/ABCDEFG123"'
    )
    assert_includes(
      email.html_part.to_s,
      'Sarah Becker has invited you to join our <strong>Nashville '\
        'Predators</strong> group'
    )
  end

  test 'send group message' do
    sending_user = User.find(1)
    group = Group.find(1)
    recipient_users = group.members

    email = GroupNotifier.send_group_message(
      group,
      sending_user,
      recipient_users,
      'Anyone want to go to the game on Friday?',
      "I'll have an extra ticket to spare.\n\nFree to a good home."
    ).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [ENV['SEATSHARE_EMAIL_FROM']], email.from
    assert_equal ['stonej@example.net'], email.reply_to
    assert_equal(
      [
        'stonej@example.net',
        'jillsmith83@us.example.org',
        'rick.taylor@example.net'
      ],
      email.to
    )
    assert_equal(
      '[Geeks Watching Hockey] Anyone want to go to the game on Friday?',
      email.subject
    )
    assert_includes(
      email.html_part.to_s,
      '<title>[Geeks Watching Hockey] Anyone want to go to the game '\
        'on Friday?</title>'
    )
    assert_includes(
      email.html_part.to_s,
      "I'll have an extra ticket to spare.</p>"
    )
    assert_includes email.html_part.to_s, 'Free to a good home.</p>'
  end
end
