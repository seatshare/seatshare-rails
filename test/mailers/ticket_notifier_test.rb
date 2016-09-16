require 'test_helper'

##
# Ticket Notifier test
class TicketNotifierTest < ActionMailer::TestCase
  ##
  # Setup test
  def setup
    Time.zone = 'Central Time (US & Canada)'
  end

  test 'ticket assigned to user' do
    ticket = Ticket.find(7)
    user = User.find(3)

    email = TicketNotifier.assign(ticket, user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal email.from, ['no-reply@myseatshare.com']
    assert_equal email.to, ['jillsmith83@us.example.org']
    assert_equal(
      email.subject,
      'Rick has assigned you a ticket via Geeks Watching Hockey'
    )
    assert_includes email.html_part.to_s, 'Jill,</p>'
    assert_includes email.html_part.to_s, 'mailto:rick.taylor@example.net'
    assert_includes email.html_part.to_s, 'Rick Taylor'
    assert_includes(
      email.html_part.to_s,
      'has assigned a ticket to you for the following event in your group'\
        ' Geeks Watching Hockey.</p>'
    )
    fails_intermittently(
      'https://github.com/stephenyeargin/seatshare-rails/issues/109',
      'Rails.configuration.time_zone' => Rails.configuration.time_zone,
      'Time.zone.name' => Time.zone.name, 'user.timezone' => user.timezone
    ) do
      assert_includes(
        email.html_part.to_s,
        'Nashville Predators vs. St. Louis Blues : Saturday, '\
          'October 26, 2013 - 8:00 pm CDT</td>'
      )
    end
    assert_includes(
      email.html_part.to_s, 'http://localhost:3000/groups/1/event-4/ticket-7'
    )
    assert_includes email.html_part.to_s, '326 K 13</a></td>'
  end

  test 'ticket requested from user' do
    ticket = Ticket.find(2)
    user = User.find(2)

    email = TicketNotifier.request_ticket(ticket, user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal email.from, ['no-reply@myseatshare.com']
    assert_equal email.to, ['stonej@example.net']
    assert_equal(
      email.subject,
      'Jill has requested your ticket via Geeks Watching Hockey'
    )
    assert_includes email.html_part.to_s, 'Jim,</p>'
    assert_includes email.html_part.to_s, 'Jill Smith'
    assert_includes email.html_part.to_s, 'mailto:jillsmith83@us.example.org'
    assert_includes(
      email.html_part.to_s,
      'has requested your ticket for the following event in your group'\
        ' Geeks Watching Hockey.'
    )
    fails_intermittently(
      'https://github.com/stephenyeargin/seatshare-rails/issues/109',
      'Rails.configuration.time_zone' => Rails.configuration.time_zone,
      'Time.zone.name' => Time.zone.name,
      'user.timezone' => user.timezone
    ) do
      assert_includes(
        email.html_part.to_s,
        'Nashville Predators vs. St. Louis Blues : Saturday, October 26, '\
          '2013 - 8:00 pm CDT</td>'
      )
    end
    assert_includes(
      email.html_part.to_s, 'http://localhost:3000/groups/1/event-4/ticket-2'
    )
    assert_includes email.html_part.to_s, '326 K 10'
  end
end
