require 'test_helper'

class TicketNotifierTest < ActionMailer::TestCase

  test "ticket assigned to user" do
    ticket = Ticket.find(3)
    user = User.find(1)

    email = TicketNotifier.assign(ticket, user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@seatsha.re'], email.from
    assert_equal ['jillsmith83@us.example.org'], email.to
    assert_equal 'Jill has assigned you a ticket via Nashville Fans of Ballsports', email.subject
    assert_includes email.body.to_s, '<p>Jill,</p>'
    assert_includes email.body.to_s, '<p>Jim Stone (<a href="mailto:stonej@example.net">stonej@example.net</a>) has assigned a ticket to you for the following event in your group Nashville Fans of Ballsports.</p>'
    assert_includes email.body.to_s, '<td>Belmont Bruins vs. Lipscomb : Wednesday, November 20, 2013</td>'
    assert_includes email.body.to_s, '<td><a href="http://localhost:3000/groups/2/event-2/ticket-3">201 P 13</a></td>'
    assert_includes email.body.to_s, '<td><a href="https://lockbox.seatsha.re/abcdefg7890.pdf">ABCDEFG-7890.pdf</a></td>'
  end
end
