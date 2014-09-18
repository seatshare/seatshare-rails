require 'test_helper'

class CustomDeviseMailerTest < ActionMailer::TestCase
  def setup
    ActionMailer::Base.deliveries = []
    Devise.mailer = 'CustomDeviseMailer'
  end

  def user
    @user ||= begin
      user = User.find(1)
      user.send_reset_password_instructions
      user
    end
  end

  def mail
    @mail ||= begin
      user
      ActionMailer::Base.deliveries.last
    end
  end

  test 'email sent after reseting the user password' do
    assert_not_nil mail
  end

  test 'content type should be set to html' do
    assert mail.content_type.include?('text/html')
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

  test 'body should have link to confirm the account' do
    if mail.body.encoded =~ %r{<a href=\"http://localhost:3000/password/edit\?reset_password_token=([^"]+)">}
      assert_equal Devise.token_generator.digest(user.class, :reset_password_token, $1), user.reset_password_token
    else
      flunk "expected reset password url regex to match"
    end
  end

end
