class GroupNotifier < ActionMailer::Base
  default from: "no-reply@seatsha.re"
  layout 'email'

  def create_invite(invite)
    @invite = invite
    @recipient = invite.email
    @user = invite.user
    @group = invite.group

    mail(
      to: @recipient,
      subject: "You have been invited to join #{@group.group_name}"
    )
  end

end