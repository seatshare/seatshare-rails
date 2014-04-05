require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  test "should get show" do
    @user = User.find(1)
    sign_in :user, @user

    get :show, :id => 3

    assert_response :success, 'received 200 status'
    assert_select 'title', 'Rick Taylor', 'page title matches'
  end

  test "should get edit" do
    @user = User.find(1)
    sign_in :user, @user

    get :edit

    assert_response :success, 'received 200 status'
    assert_select 'title', 'Edit Profile', 'page title matches'
  end

end
