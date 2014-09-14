class GroupNotifier < ActionMailer::Base
  default from: "no-reply@myseatshare.com"
  layout 'email'

  def create_invite(invite, message=nil)
    @invite = invite
    @recipient = invite.email
    @user = invite.user
    @group = invite.group
    @personalized = message

    mail(
      to: @recipient,
      subject: "You have been invited to join #{@group.group_name}"
    )

    headers['X-MC-Tags'] = 'InviteUser'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'

  end

  def send_group_message(group, sender, recipients, subject=nil, message=nil)

    if group.blank? || sender.blank? || recipients.blank? || message.blank?
      return false
    end

    if subject.blank?
      subject = "[#{group.display_name}] A message from #{sender.display_name}"
    else
      subject = "[#{group.display_name}] #{subject}"
    end

    @group = group
    @sender = sender
    @recipients = recipients
    @subject = subject
    @message = message

    @email_recipients = []
    for recipient in recipients
      @email_recipients << "#{recipient.display_name} <#{recipient.email}>"
    end

    mail(
      from: "#{sender.display_name} <#{sender.email}>",
      to: @email_recipients.join(', '),
      subject: subject
    )

    headers['X-MC-Tags'] = 'GroupMessage'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'

  end

end
