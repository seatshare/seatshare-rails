require 'test_helper'

class TicketFlowTest < ActionDispatch::IntegrationTest
  fixtures :users

  test 'add a single ticket' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues'

    post_via_redirect(
      '/groups/1/event-4/add-ticket',
      ticket: {
        section: '325',
        row: 'L',
        seat: '9',
        event_id: 4,
        cost: '40.00',
        note: 'added a note'
      }
    )

    assert_response :success
    assert_equal '/groups/1/event-4', path
    assert_equal 'Ticket added!', flash[:notice]
  end

  test 'add a single ticket - no section' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues'

    post_via_redirect(
      '/groups/1/event-4/add-ticket',
      ticket: { event_id: 4, cost: '40.00', note: 'added a note' }
    )

    assert_response :success
    assert_equal '/groups/1/event-4/add-ticket', path
    assert_equal 'Could not create ticket.', flash[:error]
  end

  test 'add season tickets' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues'

    post_via_redirect(
      '/groups/1/add-tickets',
      ticket: {
        event_id: [3, 4],
        section: '100',
        row: 'R',
        seat: 2,
        cost: '40.00',
        note: 'added a note'
      }
    )

    assert_response :success
    assert_equal '/groups/1', path
    assert_equal 'Tickets added!', flash[:notice]
  end

  test 'add season tickets - no section' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues'

    post_via_redirect(
      '/groups/1/add-tickets',
      ticket: { event_id: [3, 4], cost: '40.00', note: 'added a note' }
    )

    assert_response :success
    assert_equal '/groups/1/add-tickets', path
    assert_equal 'Could not create tickets.', flash[:error]
  end

  test 'add season tickets - no events' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues'

    post_via_redirect(
      '/groups/1/add-tickets',
      ticket: {
        section: '325',
        row: 'J',
        seat: 5,
        cost: '40.00',
        note: 'added a note'
      }
    )

    assert_response :success
    assert_equal '/groups/1/add-tickets', path
    assert_equal 'No events selected.', flash[:error]
  end

  test 'edit a ticket' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4/ticket-1'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues - 326 K 9'

    post_via_redirect(
      '/groups/1/event-4/ticket-1',
      ticket: { cost: '40.00', note: 'added a note' }
    )

    assert_response :success
    assert_equal '/groups/1/event-4', path
    assert_equal 'Ticket updated!', flash[:notice]
  end

  test 'request a ticket' do
    post_via_redirect(
      '/login',
      user: { email: users(:jill).email, password: 'testing123' }
    )

    get '/groups/1/event-4/ticket-1/request'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues - 326 K 9'

    patch_via_redirect(
      '/groups/1/event-4/ticket-1/request',
      message: { personalization: 'requesting a ticket' }
    )
    assert_response :success
    assert_equal '/groups/1/event-4', path
    assert_equal 'Ticket request sent!', flash[:notice]
  end

  test 'assign a ticket' do
    post_via_redirect(
      '/login', user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4/ticket-1'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues - 326 K 9'

    post_via_redirect(
      '/groups/1/event-4/ticket-1',
      ticket: { user_id: 2, cost: '40.00', note: 'added a note' }
    )

    assert_response :success
    assert_equal '/groups/1/event-4', path
    assert_equal 'Ticket updated!', flash[:notice]
  end

  test 'unassign a ticket' do
    post_via_redirect(
      '/login', user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4/ticket-1/unassign'

    assert_response :redirect
    assert_equal 'Ticket unassigned!', flash[:notice]
  end

  test 'delete a ticket' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/groups/1/event-4/ticket-1/delete'

    assert_response :redirect
    assert_equal 'Ticket deleted!', flash[:notice]
  end

  test 'bulk edit tickets - future' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    post_via_redirect(
      '/tickets',
      ticket_cost: { '1' => '10.00', '2' => '15.00' }, tickets: { filter: nil }
    )

    assert_response :success
    assert_equal 'Tickets updated!', flash[:notice]
  end

  test 'bulk edit tickets - past' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    post_via_redirect(
      '/tickets',
      ticket_cost: { '2' => '15.00' }, tickets: { filter: 'past' }
    )

    assert_response :success
    assert_equal 'Tickets updated!', flash[:notice]
  end

  test 'bulk edit tickets - not owner' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    post_via_redirect(
      '/tickets',
      ticket_cost: { '4' => '15.00' }, tickets: { filter: nil }
    )

    assert_response :success
    assert_equal 'Ticket cost could not be updated.', flash[:error]
  end
end
