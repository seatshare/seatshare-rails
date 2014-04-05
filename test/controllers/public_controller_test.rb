require 'test_helper'

class PublicControllerTest < ActionController::TestCase
  test "gets home page when not logged in" do
    get :index
    assert_response :success, 'got home page'
    assert_select 'title', 'SeatShare', 'title matches expected'
    assert_select 'h1', 'What is SeatShare?', 'page heading matches'
  end

  test "gets redirected when logged in" do 
    @user = User.find(1)
    sign_in :user, @user

    get :index
    assert_response 302, 'redirected to groups page'
  end

  test "gets terms of service page" do
    get :tos
    assert_response :success, 'loaded page with a 200'
    assert_select 'title', 'Terms of Service', 'title matches expected'
    assert_select 'h1', 'Terms of Service', 'page heading matches'
  end

  test "gets privacy policy page" do
    get :privacy
    assert_response :success, 'loaded page with a 200'
    assert_select 'title', 'Privacy Policy', 'title matches expected'
    assert_select 'h1', 'Privacy Policy', 'page heading matches'
  end

  test "gets contact page" do
    get :contact
    assert_response :success, 'loaded page with a 200'
    assert_select 'title', 'Contact', 'title matches expected'
    assert_select 'h1', 'Have questions or comments?', 'page heading matches'
  end

end
