require 'test_helper'

class TicketNotifierTest < ActionMailer::TestCase

  test "ticket assigned to user" do
    ticket = Ticket.find(7)
    user = User.find(3)

    email = TicketNotifier.assign(ticket, user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal email.from, ['no-reply@myseatshare.com']
    assert_equal email.to, ['jillsmith83@us.example.org']
    assert_equal email.subject, 'Rick has assigned you a ticket via Geeks Watching Hockey'
    assert_includes email.body.to_s, '<p>Jill,</p>'
    assert_includes email.body.to_s, '<p>Rick Taylor (<a href="mailto:rick.taylor@example.net">rick.taylor@example.net</a>) has assigned a ticket to you for the following event in your group Geeks Watching Hockey.</p>'
    assert_includes email.body.to_s, '<td>Nashville Predators vs. St. Louis Blues : Saturday, October 26, 2013 - 2:00 pm CDT</td>'
    assert_includes email.body.to_s, '<td><a href="http://localhost:3000/groups/1/event-4/ticket-7">326 K 13</a></td>'
  end

  test "ticket requested from user" do
    ticket = Ticket.find(2)
    user = User.find(2)

    email = TicketNotifier.request_ticket(ticket, user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal email.from, ['no-reply@myseatshare.com']
    assert_equal email.to, ['stonej@example.net']
    assert_equal email.subject, 'Jill has requested your ticket via Geeks Watching Hockey'
    assert_includes email.body.to_s, '<p>Jim,</p>'
    assert_includes email.body.to_s, '<p>Jill Smith (<a href="mailto:jillsmith83@us.example.org">jillsmith83@us.example.org</a>) has requested your ticket for the following event in your group Geeks Watching Hockey.</p>'
    assert_includes email.body.to_s, '<td>Nashville Predators vs. St. Louis Blues : Saturday, October 26, 2013 - 2:00 pm CDT</td>'
    assert_includes email.body.to_s, '<td><a href="http://localhost:3000/groups/1/event-4/ticket-2">326 K 10</a></td>'
  end
end
