require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  test "should be redirected" do
    get :edit, :group_id => 1, :event_id => 1, :id => 2

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test "should get edit" do
    @user = User.find(1)
    sign_in :user, @user

    get :edit, :group_id => 1, :event_id => 1, :id => 2

    assert_response :success, 'received 200 status'
    assert_select 'title', 'Belmont Bruins vs. Brescia - 326 K 10', 'ticket edit title matches'
  end

  test "should unassign ticket" do
    @user = User.find(1)
    sign_in :user, @user

    get :unassign, :group_id => 1, :event_id => 1, :id => 2

    assert_response :redirect, 'received a redirect'
    assert_redirected_to '/groups/1/event-1'
  end

  test "should delete ticket" do
    @user = User.find(1)
    sign_in :user, @user

    get :delete, :group_id => 1, :event_id => 1, :id => 2

    assert_response :redirect, 'received a redirect'
    assert_redirected_to '/groups/1/event-1'
  end

  test "should get edit denied" do
    @user = User.find(2)
    sign_in :user, @user

    assert_raise RuntimeError do
      get :edit, :group_id => 1, :event_id => 1, :id => 2
    end
  end

  test "should get request" do
    @user = User.find(2)
    sign_in :user, @user

    get :request_ticket, :group_id => 1, :event_id => 1, :id => 2

    assert_response :success, 'received 200 status'
    assert_select 'title', 'Belmont Bruins vs. Brescia - 326 K 10', 'ticket request title matches'
  end 

end
