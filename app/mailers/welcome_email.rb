##
# Welcome email
class WelcomeEmail < ActionMailer::Base
  default from: ENV['SEATSHARE_EMAIL_FROM']
  layout 'email'

  ##
  # Send welcome email
  def welcome(user = nil)
    @recipient = user

    mail(
      to: "#{@recipient.display_name} <#{@recipient.email}>",
      subject: "Welcome to SeatShare, #{@recipient.first_name}!",
      reply_to: "SeatShare Support <#{ENV['SEATSHARE_EMAIL_SUPPORT']}>",
    )

    headers['X-Mailgun-Tag'] = 'NewUser'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
  end
end
