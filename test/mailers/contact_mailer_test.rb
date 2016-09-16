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
    ).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['john@example.com'], email.from
    assert_equal ['john@example.com'], email.reply_to
    assert_equal ['contact@myseatshare.com'], email.to
    assert_equal 'This is a sample message', email.subject

    assert_includes(
      email.html_part.to_s,
      "This is a long message that\r\n<br> has a line break "\
      "or\r\n<br> two in it.</p>"
    )
  end
end
