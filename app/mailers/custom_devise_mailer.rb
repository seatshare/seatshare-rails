##
# Custom Devise Mailer class
class CustomDeviseMailer < Devise::Mailer
  default from: ENV['SEATSHARE_EMAIL_FROM']
  layout 'email'

  helper :application
  include Devise::Controllers::UrlHelpers

  ##
  # Send password reset instructions
  # - record: User object
  # - token: string of confirmation token
  # - opts: object of options to pass to super
  def reset_password_instructions(record, token, opts = {})
    @view_action = {
      url: url_for(edit_password_url(record, reset_password_token: @token)),
      action: 'Reset Password',
      description: 'Click to select a new password.'
    }

    headers['X-Mailgun-Tag'] = 'ResetPasswordInstructions'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
    super
  end
end
