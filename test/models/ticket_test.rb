require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  test "new ticket has attributes" do
    ticket = Ticket.new({
      :group_id => 1,
      :event_id => 4,
      :section => '301',
      :row => 'Q',
      :seat => '3',
      :cost => 45.00,
      :owner_id => 1,
      :user_id => 2
    })
    ticket.save!

    assert ticket.cost === 45.00
    assert ticket.display_name === '301 Q 3'
    assert ticket.owner.display_name === 'Jim Stone'
    assert ticket.assigned.display_name === 'Jill Smith'
    assert ticket.group.group_name === 'Geeks Watching Hockey'
    assert ticket.event.event_name === 'Nashville Predators vs. St. Louis Blues'
  end

  test "owner property is set" do
    ticket = Ticket.find(1)

    assert ticket.owner.display_name === 'Jim Stone'
  end

  test "assigned property is set" do
    ticket = Ticket.find(1)

    assert ticket.assigned.display_name === 'Jim Stone'

    ticket = Ticket.find(2)

    assert ticket.assigned.nil? === true
  end

  test "alias property is set" do
    ticket = Ticket.find(4)

    assert ticket.alias.display_name === 'Jennifer Newton'

    ticket = Ticket.find(1)

    assert ticket.alias.nil? === true
  end

  test "group property is set" do
    ticket = Ticket.find(1)

    assert ticket.group.group_name === 'Geeks Watching Hockey'
  end

  test "display_name property is set" do
    ticket = Ticket.find(1)

    assert ticket.display_name === '326 K 9'

    ticket = Ticket.find(5)

    assert ticket.display_name === 'VIP'
  end

  test "is_available? check" do
    ticket = Ticket.find(1)

    assert ticket.is_available? === false

    ticket = Ticket.find(2)

    assert ticket.is_available? === true
  end

  test "is_assigned? check" do
    ticket = Ticket.find(1)

    assert ticket.is_assigned? === true

    ticket = Ticket.find(2)

    assert ticket.is_assigned? === false
  end

end
