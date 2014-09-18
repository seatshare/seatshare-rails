class CustomDeviseMailer < Devise::Mailer
  default from: "no-reply@myseatshare.com"
  layout 'email'

  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def confirmation_instructions(record, token, opts={})
    headers['X-MC-Tags'] = 'ConfirmationInstructions'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
    super
  end

  def reset_password_instructions(record, token, opts={})
    headers['X-MC-Tags'] = 'ResetPasswordInstructions'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
    super
  end

  def unlock_instructions(record, token, opts={})
    headers['X-MC-Tags'] = 'UnlockInstructions'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
    super
  end

end