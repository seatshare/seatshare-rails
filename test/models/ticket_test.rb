require 'test_helper'

##
# Ticket test
class TicketTest < ActiveSupport::TestCase
  ##
  # Setup test
  def setup
    Time.zone = 'Central Time (US & Canada)'
  end

  test 'new ticket has attributes' do
    ticket = Ticket.new(
      group_id: 1,
      event_id: 4,
      section: '301',
      row: 'Q',
      seat: '3',
      cost: 45.00,
      owner_id: 1,
      user_id: 2
    )
    ticket.save!

    assert ticket.cost == 45.00
    assert ticket.display_name == '301 Q 3'
    assert ticket.owner.display_name == 'Jim Stone'
    assert ticket.assigned.display_name == 'Jill Smith'
    assert ticket.group.group_name == 'Geeks Watching Hockey'
    assert ticket.event.event_name == 'Nashville Predators vs. St. Louis Blues'
  end

  test 'owner property is set' do
    ticket = Ticket.find(1)

    assert ticket.owner.display_name == 'Jim Stone'
  end

  test 'assigned property is set' do
    ticket = Ticket.find(1)

    assert ticket.assigned.display_name == 'Jim Stone'

    ticket = Ticket.find(2)

    assert ticket.assigned.nil? == true
  end

  test 'alias property is set' do
    ticket = Ticket.find(4)

    assert ticket.alias.display_name == 'Jennifer Newton'

    ticket = Ticket.find(1)

    assert ticket.alias.nil? == true
  end

  test 'group property is set' do
    ticket = Ticket.find(1)

    assert ticket.group.group_name == 'Geeks Watching Hockey'
  end

  test 'display_name property is set' do
    ticket = Ticket.find(1)

    assert ticket.display_name == '326 K 9'

    ticket = Ticket.find(5)

    assert ticket.display_name == 'VIP'
  end

  test 'available? check' do
    ticket = Ticket.find(1)

    assert ticket.available? == false

    ticket = Ticket.find(2)

    assert ticket.available? == true
  end

  test 'assigned? check' do
    ticket = Ticket.find(1)

    assert ticket.assigned? == true

    ticket = Ticket.find(2)

    assert ticket.assigned? == false
  end

  test 'unassign' do
    ticket = Ticket.find(4)
    ticket.unassign

    assert ticket.assigned? == false
    assert ticket.user_id == 0
    assert ticket.alias_id == 0
  end

  test 'can_edit?' do
    ticket = Ticket.find(3)
    user = User.find(1)

    assert ticket.can_edit?(user)

    user = User.find(2)

    assert ticket.can_edit?(user)

    user = User.find(3)

    assert !ticket.can_edit?(user)
  end

  test 'log_ticket_history' do
    acting_user = User.find(2)
    ticket = Ticket.find(4)
    ticket.user_id = 3
    ticket.save!

    assert ticket.ticket_histories.count == 0

    Ticket.log_ticket_history ticket, 'assigned', acting_user
    entry = JSON.parse(ticket.ticket_histories[0].entry)

    assert ticket.ticket_histories.count == 1
    assert entry['text'] == 'assigned'
    assert entry['user']['id'] == 3
    assert entry['ticket']['user_id'] == 3
  end
end
