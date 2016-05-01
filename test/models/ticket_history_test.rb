require 'test_helper'

##
# Ticket History test
class TicketHistoryTest < ActiveSupport::TestCase
  test 'new ticket history' do
    ticket_history = TicketHistory.new(
      ticket_id: 1,
      event_id: 4,
      group_id: 1,
      user_id: 1,
      entry: '{"text":"assigned","user":{"id":"1","username":"jstone",'\
        '"first_name":"Jim","last_name":"Stone","email":"stonej@example.net",'\
        '"status":true},"ticket":{"id":"1","section":"326","row":"K",'\
        '"seat":"9","cost":"32.00","user_id":"1","ticket_id":1}}'
    )
    ticket_history.save!

    assert_equal 1, ticket_history.ticket_id
    assert_equal 4, ticket_history.event_id
    assert_equal 1, ticket_history.group_id
    assert_equal 1, ticket_history.user_id
    assert_equal 'assigned', JSON.parse(ticket_history.entry)['text']
  end

  test 'ticket property is set' do
    ticket_history = TicketHistory.find(1)

    assert_equal '326 K 9', ticket_history.ticket.display_name
  end

  test 'event property is set' do
    ticket_history = TicketHistory.find(1)

    assert_equal(
      'Nashville Predators vs. St. Louis Blues',
      ticket_history.event.event_name
    )
  end

  test 'group property is set' do
    ticket_history = TicketHistory.find(1)

    assert_equal 'Geeks Watching Hockey', ticket_history.group.group_name
  end

  test 'user property is set' do
    ticket_history = TicketHistory.find(1)

    assert_equal 'Jim Stone', ticket_history.user.display_name
  end
end
