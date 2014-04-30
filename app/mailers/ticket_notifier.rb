class TicketNotifier < ActionMailer::Base
  default from: "no-reply@seatsha.re"
  layout 'email'

  def assign(ticket=nil, user=nil)
    @ticket = ticket
    @event = ticket.event
    @recipient = ticket.assigned
    @group = ticket.group
    @user = user

    mail(
      to: @recipient.email,
      subject: "#{@recipient.first_name} has assigned you a ticket via #{@group.group_name}"
    )
  end

end
