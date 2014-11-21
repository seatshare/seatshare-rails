require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test 'should be redirected' do
    get :show, id: 1, group_id: 2

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test 'should get show' do
    @user = User.find(1)
    sign_in :user, @user

    get :show, id: 1, group_id: 2

    assert_response :success, 'received a 200 status'
    assert_select 'title', 'Belmont Bruins vs. Brescia', 'event title matches'
    assert_select 'table', 1, 'there is a table for tickets'
  end

  test 'should see localized timezone' do
    @user = User.find(2)
    sign_in :user, @user

    get :show, id: 4, group_id: 1

    assert_response :success, 'received a 200 status'
    assert_select(
      'div.panel-heading',
      'Saturday, October 26, 2013 - 3:00 pm EDT'
    )
  end

  test 'should get the correct ticket counts' do
    @user = User.find(1)
    sign_in :user, @user

    get :show, id: 4, group_id: 1

    assert_response :success, 'received a 200 status'
    assert_select 'li.available-ticket-count', '1 available in the group'
    assert_select 'li.total-ticket-count', '4 total in the group'
    assert_select 'li.held-ticket-count', '1 held by you'
  end
end
