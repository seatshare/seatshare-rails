require 'test_helper'

class TicketNotifierTest < ActionMailer::TestCase

  test "ticket assigned to user" do
    ticket = Ticket.find(3)
    user = User.find(1)

    email = TicketNotifier.assign(ticket, user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal email.from, ['no-reply@myseatshare.com']
    assert_equal email.to, ['jillsmith83@us.example.org']
    assert_equal email.subject, 'Jim has assigned you a ticket via Nashville Fans of Ballsports'
    assert_includes email.body.to_s, '<p>Jill,</p>'
    assert_includes email.body.to_s, '<p>Jim Stone (<a href="mailto:stonej@example.net">stonej@example.net</a>) has assigned a ticket to you for the following event in your group Nashville Fans of Ballsports.</p>'
    assert_includes email.body.to_s, '<td>Belmont Bruins vs. Lipscomb : Wednesday, November 20, 2013</td>'
    assert_includes email.body.to_s, '<td><a href="http://localhost:3000/groups/2/event-2/ticket-3">201 P 13</a></td>'
    assert_includes email.body.to_s, '<td><a href="https://lockbox.myseatshare.com/abcdefg7890.pdf">ABCDEFG-7890.pdf</a></td>'
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
    assert_includes email.body.to_s, '<td>Nashville Predators vs. St. Louis Blues : Saturday, October 26, 2013</td>'
    assert_includes email.body.to_s, '<td><a href="http://localhost:3000/groups/1/event-4/ticket-2">326 K 10</a></td>'
  end
end
