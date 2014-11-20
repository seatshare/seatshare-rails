class CustomDeviseMailer < Devise::Mailer
  default from: 'no-reply@myseatshare.com'
  layout 'email'

  helper :application
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, opts = {})
    @view_action = {
      url: url_for(confirmation_url(record, confirmation_token: @token)),
      action: 'Confirm Account',
      description: 'Click to confirm your account.'
    }

    headers['X-MC-Tags'] = 'ConfirmationInstructions'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
    super
  end

  def reset_password_instructions(record, token, opts = {})
    @view_action = {
      url: url_for(edit_password_url(record, reset_password_token: @token)),
      action: 'Reset Password',
      description: 'Click to select a new password.'
    }

    headers['X-MC-Tags'] = 'ResetPasswordInstructions'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
    super
  end

  def unlock_instructions(record, token, opts = {})
    @view_action = {
      url: url_for(unlock_url(record, unlock_token: @token)),
      action: 'Unlock Account',
      description: 'Click to unlock your account.'
    }

    headers['X-MC-Tags'] = 'UnlockInstructions'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
    super
  end
end
