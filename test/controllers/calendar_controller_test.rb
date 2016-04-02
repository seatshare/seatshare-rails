require 'test_helper'

##
# Calendar Controller Test
class CalendarControllerTest < ActionController::TestCase
  ##
  # Setup test
  def setup
    Time.zone = 'Central Time (US & Canada)'
  end

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
    assert response.body.include? 'NAME:SeatShare'
    assert response.body.include? 'BEGIN:VEVENT'
    assert response.body.include? 'UID:preds_20131024'
    fails_intermittently(
      'https://github.com/stephenyeargin/seatshare-rails/issues/256',
      'Rails.configuration.time_zone' => Rails.configuration.time_zone,
      'Time.zone.name' => Time.zone.name, 'user.timezone' => @user.timezone,
      'response.body' => response.body
    ) do
      assert response.body.include? 'DTSTART:20131024T200000'
      assert response.body.include? 'DTEND:20131024T230000'
    end
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
    assert response.body.include? 'NAME:Geeks Watching Hockey'
    assert response.body.include? 'BEGIN:VEVENT'
    assert response.body.include? 'UID:preds_20131026'
    fails_intermittently(
      'https://github.com/stephenyeargin/seatshare-rails/issues/256',
      'Rails.configuration.time_zone' => Rails.configuration.time_zone,
      'Time.zone.name' => Time.zone.name, 'user.timezone' => @user.timezone,
      'response.body' => response.body
    ) do
      assert response.body.include? 'DTSTART:20131026T200000'
      assert response.body.include? 'DTEND:20131026T230000'
    end
    assert response.body.include? 'CLASS:PUBLIC'
    assert response.body.include? 'LOCATION:'
    assert response.body.include? 'SUMMARY:Nashville Predators vs. St. Louis'
    assert response.body.include? 'URL:http://test.host/groups/1/event-4'
    assert response.body.include? 'END:VEVENT'
  end
end
