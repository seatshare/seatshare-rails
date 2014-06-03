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
      to: "#{@recipient.full_name} <#{@recipient.email}>",
      subject: "#{@user.first_name} has assigned you a ticket via #{@group.group_name}"
    )
  end

  def request_ticket(ticket=nil, user=nil, message=nil)
    @ticket = ticket
    @event = ticket.event
    @recipient = ticket.owner
    @group = ticket.group
    @user = user
    @message = message

    mail(
      to: "#{@recipient.full_name} <#{@recipient.email}>",
      subject: "#{@user.first_name} has requested your ticket via #{@group.group_name}"
    )
  end
end
