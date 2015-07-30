require 'test_helper'

##
# Contact Mailer Test
class ContactMailerTest < ActionMailer::TestCase
  test 'send support ticket' do
    email = ContactMailer.support_ticket(
      'John Doe',
      'john@example.com',
      'This is a sample message',
      "This is a long message that\n has a line break or\n two in it."
    ).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['john@example.com'], email.from
    assert_equal ['john@example.com'], email.reply_to
    assert_equal ['contact@myseatshare.com'], email.to
    assert_equal 'This is a sample message', email.subject

    assert_includes(
      email.body.to_s,
      "<p>This is a long message that\n<br /> has a line "\
      "break or\n<br /> two in it.</p>"
    )
  end
end
