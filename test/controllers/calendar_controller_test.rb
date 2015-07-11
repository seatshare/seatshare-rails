require 'test_helper'

##
# Calendar Controller Test
class CalendarControllerTest < ActionController::TestCase
  test 'get calendar index' do
    @user = User.find(1)
    sign_in :user, @user

    get :index

    assert_response :success
    assert_select 'title', 'Events Calendar Feeds'
    assert_select 'h1', 'Calendar Feeds'
  end

  test 'get full calendar' do
    @user = User.find(1)

    get :full, token: @user.calendar_token, format: 'ics'

    assert_response :success
    assert response.body.include? 'BEGIN:VEVENT'
    assert response.body.include? 'UID:preds_20131024'
    assert response.body.include? 'DTSTART:20131026T140000'
    assert response.body.include? 'DTEND:20131026T170000'
    assert response.body.include? 'CLASS:PUBLIC'
    assert response.body.include? 'LOCATION:'
    assert response.body.include? 'SUMMARY:Nashville Predators vs. Winnipeg'
    assert response.body.include? 'URL:http://test.host/groups/1/event-5'
    assert response.body.include? 'END:VEVENT'
  end

  test 'get group calendar' do
    @user = User.find(1)

    get :group, group_id: 1, token: @user.calendar_token, format: 'ics'

    assert_response :success
    assert response.body.include? 'BEGIN:VEVENT'
    assert response.body.include? 'UID:preds_20131026'
    assert response.body.include? 'DTSTART:20131026T140000'
    assert response.body.include? 'DTEND:20131026T170000'
    assert response.body.include? 'CLASS:PUBLIC'
    assert response.body.include? 'LOCATION:'
    assert response.body.include? 'SUMMARY:Nashville Predators vs. St. Louis'
    assert response.body.include? 'URL:http://test.host/groups/1/event-4'
    assert response.body.include? 'END:VEVENT'
  end
end
