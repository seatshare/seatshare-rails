require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  test "owner property is set" do
    ticket = Ticket.find(1)

    assert ticket.owner.full_name === 'Jim Stone'
  end

  test "assigned property is set" do
    ticket = Ticket.find(1)

    assert ticket.assigned.full_name === 'Jim Stone'

    ticket = Ticket.find(2)

    assert ticket.assigned.nil? === true
  end

  test "alias property is set" do
    ticket = Ticket.find(4)

    assert ticket.alias.full_name === 'Jennifer Newton'

    ticket = Ticket.find(1)

    assert ticket.alias.nil? === true
  end

  test "group property is set" do
    ticket = Ticket.find(1)

    assert ticket.group.group_name === 'Geeks Watching Hockey'
  end

  test "section_row_set property is set" do
    ticket = Ticket.find(1)

    assert ticket.section_row_seat === '326 K 9'

    ticket = Ticket.find(5)

    assert ticket.section_row_seat === 'VIP'
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
