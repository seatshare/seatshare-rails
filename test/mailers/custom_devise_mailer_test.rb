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

  ##
  # Get user
  def user
    @user ||= begin
      user = User.find(1)
      user.send_reset_password_instructions
      user
    end
  end

  ## Send mail
  def mail
    @mail ||= begin
      user
      ActionMailer::Base.deliveries.last
    end
  end

  test 'email sent after reseting the user password' do
    assert_not_nil mail
  end

  test 'content type should be set to multipart' do
    assert mail.content_type.include?('multipart/alternative')
  end

  test 'send confirmation instructions to the user email' do
    assert_equal [user.email], mail.to
  end

  test 'setup sender from configuration' do
    assert_equal ['no-reply@myseatshare.com'], mail.from
  end

  test 'body should have user info' do
    assert_match user.email, mail.body.encoded
  end
end
