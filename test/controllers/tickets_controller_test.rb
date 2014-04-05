require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  test "should get edit" do
    @user = User.find(1)
    sign_in :user, @user

    get :edit, :group_id => 1, :event_id => 1, :id => 2

    assert_response :success, 'received 200 status'
    assert_select 'title', '326 K 10 | Belmont Bruins vs. Brescia', 'ticket edit title matches'
  end

end
