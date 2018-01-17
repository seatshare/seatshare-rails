
##
# Contact Mailer
class ContactMailer < ActionMailer::Base
  default from: ENV['SEATSHARE_EMAIL_FROM']

  ##
  # Send Support Ticket
  # - name: string of name
  # - email: string of email
  # - subject: string of message subject
  # - message: string of message body
  def support_ticket(name, email, subject, message)
    if name.blank? || email.blank? || subject.blank? || message.blank?
      return false
    end

    @message = message

    from = Mail::Address.new email # ex: "john@example.com"
    from.display_name = name.dup # ex: "John Doe"

    mail(
      to: "SeatShare Support <#{ENV['SEATSHARE_EMAIL_SUPPORT']}>",
      from: from.format,
      subject: subject,
      reply_to: "#{name} <#{email}>"
    )

    headers['X-Mailgun-Tag'] = 'SupportTicket'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
  end
end
