
##
# Contact Mailer
class ContactMailer < ActionMailer::Base
  default from: 'no-reply@myseatshare.com'

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
      to: 'SeatShare Support <contact@myseatshare.com>',
      from: from.format,
      subject: subject,
      reply_to: "#{name} <#{email}>"
    )

    headers['X-MC-Tags'] = 'SupportTicket'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
  end
end
