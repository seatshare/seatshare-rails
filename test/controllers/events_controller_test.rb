require 'test_helper'

##
# Events controller test
class EventsControllerTest < ActionController::TestCase
  test 'should be redirected' do
    get :show, id: 1, group_id: 2

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test 'should get show' do
    @user = User.find(1)
    sign_in :user, @user

    get :show, id: 4, group_id: 1

    assert_response :success, 'received a 200 status'
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues',
                  'event title matches'
    assert_select 'table', 1, 'there is a table for tickets'

    assert_raises 'NotFound' do
      get :show, id: 1, group_id: 2
    end
  end

  test 'should see localized timezone' do
    @user = User.find(2)
    sign_in :user, @user

    get :show, id: 4, group_id: 1

    assert_response :success, 'received a 200 status'
    assert_select(
      'span.event_date_time',
      'Saturday, October 26, 2013 - 9:00 pm EDT'
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

  test 'should get calendar event in ical format' do
    @user = User.find(1)
    sign_in :user, @user

    get :show, id: 4, group_id: 1, format: 'ics'

    assert_response :success
    assert response.body.include? 'NAME:Nashville Predators vs. St. Louis Blues'
    assert response.body.include? 'BEGIN:VEVENT'
    assert response.body.include? 'UID:preds_20131026'
    assert response.body.include? 'DTSTART:20131026T200000'
    assert response.body.include? 'DTEND:20131026T230000'
    assert response.body.include? 'CLASS:PUBLIC'
    assert response.body.include? 'LOCATION:'
    assert response.body.include? 'SUMMARY:Nashville Predators vs. St. Louis'
    assert response.body.include? 'URL:http://test.host/groups/1/event-4'
    assert response.body.include? 'END:VEVENT'
  end
end
