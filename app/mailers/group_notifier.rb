##
# Group Notifier class
class GroupNotifier < ActionMailer::Base
  default from: 'no-reply@myseatshare.com'
  layout 'email'

  ##
  # Send group invitation
  # - invite: GroupInvitation object
  # - message: string of optional message body
  def create_invite(invite, message = nil)
    @invite = invite
    @recipient = invite.email
    @user = invite.user
    @group = invite.group
    @personalized = message
    @view_action = {
      url: url_for(
        controller: 'registrations', action: 'new',
        invite_code: @invite.invitation_code, only_path: false
      ),
      action: 'Accept Invitation',
      description: 'You have received an invitation.'
    }

    mail(
      to: @recipient,
      subject: "You have been invited to join #{@group.group_name}",
      reply_to: "#{@user.display_name} <#{@user.email}>"
    )

    headers['X-Mailgun-Tag'] = 'InviteUser'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
  end

  ##
  # Send group message
  # - group: Group object
  # - sender: User object
  # - recipients: array of User objects
  # - subject: string of message subject
  # - message: string of message body
  def send_group_message(group, sender, recipients, subject, message)
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

    @view_action = {
      url: url_for(controller: 'groups', id: @group.id, only_path: false),
      action: 'View Group',
      description: 'You have received a message.'
    }

    @email_recipients = []
    recipients.each do |recipient|
      @email_recipients << "#{recipient.display_name} <#{recipient.email}>"
    end

    mail(
      to: @email_recipients.join(', '),
      subject: subject,
      reply_to: "#{sender.display_name} <#{sender.email}>"
    )

    headers['X-Mailgun-Tag'] = 'GroupMessage'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
  end
end
