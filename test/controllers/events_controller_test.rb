require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should be redirected" do
    get :show, :id => 1, :group_id => 2

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test "should get show" do
    @user = User.find(1)
    sign_in :user, @user

    get :show, :id => 1, :group_id => 2

    assert_response :success, 'received a 200 status'
    assert_select 'title', 'Belmont Bruins vs. Brescia', 'event title matches'
    assert_select 'table', 1, 'there is a table for tickets'
  end

end
