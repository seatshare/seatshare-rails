##
# Ticket Notifier class
class TicketNotifier < ActionMailer::Base
  default from: ENV['SEATSHARE_EMAIL_FROM']
  layout 'email'

  ##
  # Send ticket assignment email
  # - ticket: Ticket object
  # - acting_user: User object assigning the ticket
  def assign(ticket = nil, acting_user = nil)
    @ticket = ticket
    @event = ticket.event
    @recipient = ticket.assigned
    @group = ticket.group
    @user = acting_user

    @view_action = {
      url: url_for(
        controller: 'tickets', action: 'edit', group_id: @ticket.group_id,
        event_id: @ticket.event_id, id: @ticket.id, only_path: false
      ),
      action: 'View Ticket',
      description: 'You have been assigned a ticket.'
    }

    mail(
      to: "#{@recipient.display_name} <#{@recipient.email}>",
      subject:
        "#{@user.first_name} has assigned you a ticket via "\
        "#{@group.group_name}",
      reply_to: "#{@user.display_name} <#{@user.email}>"
    )

    headers['X-Mailgun-Tag'] = 'AssignTicket'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
  end

  ##
  # Send ticket request email
  # - ticket: Ticket object
  # - acting_user: User object assigning the ticket
  # - message: string of message body
  def request_ticket(ticket = nil, acting_user = nil, message = nil)
    @ticket = ticket
    @event = ticket.event
    @recipient = ticket.owner
    @group = ticket.group
    @user = acting_user
    @message = message

    @view_action = {
      url: url_for(
        controller: 'tickets', action: 'edit', group_id: @ticket.group_id,
        event_id: @ticket.event_id, id: @ticket.id, only_path: false
      ),
      action: 'Assign Ticket',
      description: 'Your ticket has been requested.'
    }

    mail(
      to: "#{@recipient.display_name} <#{@recipient.email}>",
      subject:
        "#{@user.first_name} has requested your ticket via"\
        " #{@group.group_name}",
      reply_to: "#{@user.display_name} <#{@user.email}>"
    )

    headers['X-Mailgun-Tag'] = 'RequestTicket'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
  end
end
