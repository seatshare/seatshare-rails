require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  test "should get index" do
    @user = User.find(2)
    sign_in :user, @user

    get :index
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Groups', 'page title matches'
    assert_select '.group_name', 2, 'page shows correct count of joined groups'
  end

  test "should see group creation page" do
    @user = User.find(1)
    sign_in :user, @user

    get :new
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Create a Group', 'page title matches'
    assert_select "form input[name='group[group_name]']", 1, 'group name field exists'
    assert_select "form select[name='group[entity_id]'] option", 5, 'select on page has five items'
  end

  test "should get group page" do
    @user = User.find(1)
    sign_in :user, @user

    get :show, {:id => 1}
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Geeks Watching Hockey', 'page title matches'
  end

end
