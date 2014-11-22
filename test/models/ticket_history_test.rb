require 'test_helper'

class TicketHistoryTest < ActiveSupport::TestCase
  test 'new ticket history' do
    ticket_history = TicketHistory.new(
      ticket_id: 1,
      event_id: 4,
      group_id: 1,
      user_id: 1,
      entry: '{"text":"assigned","user":{"id":"1","username":"jstone",'\
        '"first_name":"Jim","last_name":"Stone","email":"stonej@example.net",'\
        '"status":"1"},"ticket":{"id":"1","section":"326","row":"K",'\
        '"seat":"9","cost":"32.00","user_id":"1","ticket_id":1}}'
    )
    ticket_history.save!

    assert ticket_history.ticket_id == 1
    assert ticket_history.event_id == 4
    assert ticket_history.group_id == 1
    assert ticket_history.user_id == 1
    assert JSON.parse(ticket_history.entry)['text'] == 'assigned'
  end

  test 'ticket property is set' do
    ticket_history = TicketHistory.find(1)

    assert ticket_history.ticket.display_name == '326 K 9'
  end

  test 'event property is set' do
    ticket_history = TicketHistory.find(1)

    assert ticket_history.event.event_name ==
      'Nashville Predators vs. St. Louis Blues'
  end

  test 'group property is set' do
    ticket_history = TicketHistory.find(1)

    assert ticket_history.group.group_name == 'Geeks Watching Hockey'
  end

  test 'user property is set' do
    ticket_history = TicketHistory.find(1)

    assert ticket_history.user.display_name == 'Jim Stone'
  end
end
