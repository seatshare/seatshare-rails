require 'test_helper'

##
# Tickets controller test
class TicketsControllerTest < ActionController::TestCase
  test 'should be redirected' do
    get :edit, group_id: 1, event_id: 1, id: 2

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test 'should get edit' do
    @user = User.find(1)
    sign_in :user, @user

    get :edit, group_id: 1, event_id: 1, id: 2

    assert_response :success, 'received 200 status'
    assert_select(
      'title',
      'Belmont Bruins vs. Brescia - 326 K 10', 'ticket edit title matches'
    )
  end

  test 'should unassign ticket' do
    @user = User.find(1)
    sign_in :user, @user

    get :unassign, group_id: 1, event_id: 1, id: 2

    assert_response :redirect, 'received a redirect'
    assert_redirected_to '/groups/1/event-4'
  end

  test 'should delete ticket' do
    @user = User.find(1)
    sign_in :user, @user

    get :delete, group_id: 1, event_id: 1, id: 2

    assert_response :redirect, 'received a redirect'
    assert_redirected_to '/groups/1/event-4'
  end

  test 'should delete ticket file' do
    @user = User.find(1)
    sign_in :user, @user

    get :delete_ticket_file, group_id: 1, event_id: 4, ticket_id: 1, id: 1

    assert_response :redirect, 'received a redirect'
    assert_redirected_to '/groups/1/event-4/ticket-1'
  end

  test 'should be redirected to request' do
    @user = User.find(2)
    sign_in :user, @user

    get :edit, group_id: 1, event_id: 1, id: 2

    assert_redirected_to '/groups/1/event-1/ticket-2/request'
  end

  test 'should get request' do
    @user = User.find(2)
    sign_in :user, @user

    get :request_ticket, group_id: 1, event_id: 1, id: 2

    assert_response :success, 'received 200 status'
    assert_select(
      'title',
      'Belmont Bruins vs. Brescia - 326 K 10', 'ticket request title matches'
    )
  end

  test 'should get future tickets' do
    @user = User.find(2)
    sign_in :user, @user

    get :index

    assert_response :success, 'received 200 status'
    assert_select 'title', 'My Tickets', 'ticket request title matches'
  end

  test 'should get past tickets' do
    @user = User.find(2)
    sign_in :user, @user

    get :index, filter: 'past'

    assert_response :success, 'received 200 status'
    assert_select 'title', 'My Past Tickets', 'ticket request title matches'
  end
end
