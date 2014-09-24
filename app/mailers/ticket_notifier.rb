class TicketNotifier < ActionMailer::Base
  default from: "no-reply@myseatshare.com"
  layout 'email'

  def assign(ticket=nil, acting_user=nil)
    @ticket = ticket
    @event = ticket.event
    @recipient = ticket.assigned
    @group = ticket.group
    @user = acting_user

    @view_action = {
      url: url_for(:controller => 'tickets', :action => 'edit', :group_id => @ticket.group_id, :event_id => @ticket.event_id, :id => @ticket.id, :only_path => false),
      action: 'View Ticket',
      description: 'You have been assigned a ticket.'
    }

    mail(
      to: "#{@recipient.display_name} <#{@recipient.email}>",
      subject: "#{@user.first_name} has assigned you a ticket via #{@group.group_name}"
    )

    headers['X-MC-Tags'] = 'AssignTicket'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
  end

  def request_ticket(ticket=nil, user=nil, message=nil)
    @ticket = ticket
    @event = ticket.event
    @recipient = ticket.owner
    @group = ticket.group
    @user = user
    @message = message

    @view_action = {
      url: url_for(:controller => 'tickets', :action => 'edit', :group_id => @ticket.group_id, :event_id => @ticket.event_id, :id => @ticket.id, :only_path => false),
      action: 'Assign Ticket',
      description: 'Your ticket has been requested.'
    }

    mail(
      to: "#{@recipient.display_name} <#{@recipient.email}>",
      subject: "#{@user.first_name} has requested your ticket via #{@group.group_name}"
    )

    headers['X-MC-Tags'] = 'RequestTicket'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
  end
end
