require 'test_helper'

##
# Custom Devise Mailer test
class CustomDeviseMailerTest < ActionMailer::TestCase
  ##
  # Setup tests
  def setup
    ActionMailer::Base.deliveries = []
    Devise.mailer = 'CustomDeviseMailer'
  end

  ## Send mail
  def mail
    @mail ||= begin
      ActionMailer::Base.deliveries.last
    end
  end

  test 'email sent after reseting the user password' do
    user = User.find(1)
    user.send_reset_password_instructions

    assert_not_nil mail, 'email sent after reseting the user password'
    assert mail.content_type.include?('multipart/alternative'), 'content type should be set to multipart'
    assert_equal [user.email], mail.to, 'send confirmation instructions to the user email'
    assert_equal ['no-reply@myseatshare.com'], mail.from, 'setup sender from configuration'
    assert_match user.email, mail.body.encoded,  'message body includes email address'
  end
end
