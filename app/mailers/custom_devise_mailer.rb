##
# Custom Devise Mailer class
class CustomDeviseMailer < Devise::Mailer
  default from: 'no-reply@myseatshare.com'
  layout 'email'

  helper :application
  include Devise::Controllers::UrlHelpers

  ##
  # Send confirmation instructions
  # - record: User object
  # - token: string of confirmation token
  # - opts: object of options to pass to super
  def confirmation_instructions(record, token, opts = {})
    @view_action = {
      url: url_for(confirmation_url(record, confirmation_token: @token)),
      action: 'Confirm Account',
      description: 'Click to confirm your account.'
    }

    headers['X-Mailgun-Tag'] = 'ConfirmationInstructions'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
    super
  end

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

  ##
  # Send account unlock instructions
  # - record: User object
  # - token: string of confirmation token
  # - opts: object of options to pass to super
  def unlock_instructions(record, token, opts = {})
    @view_action = {
      url: url_for(unlock_url(record, unlock_token: @token)),
      action: 'Unlock Account',
      description: 'Click to unlock your account.'
    }

    headers['X-Mailgun-Tag'] = 'UnlockInstructions'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
    super
  end
end
