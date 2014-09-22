require 'test_helper'

class PublicControllerTest < ActionController::TestCase
  test "gets home page when not logged in" do
    get :index
    assert_response :success, 'got home page'
    assert_select 'title', 'Welcome to SeatShare', 'title matches expected'
    assert_select 'h1', 'What is SeatShare?', 'page heading matches'
  end

  test "gets redirected when logged in and has no groups" do 
    @user = User.find(6)
    sign_in :user, @user

    get :index
    assert_response :redirect, 'redirected to another page'
    assert_redirected_to :controller => 'groups', :action => 'index'
  end

  test "gets redirected when logged in and is a group member" do 
    @user = User.find(1)
    sign_in :user, @user

    get :index
    assert_response :redirect, 'redirected to another page'
    assert_redirected_to :controller => 'groups', :action => 'show', :id => 1
  end

  test "gets terms of service page" do
    get :tos
    assert_response :success, 'loaded page with a 200'
    assert_select 'title', 'Terms of Service - SeatShare', 'title matches expected'
    assert_select 'h1', 'Terms of Service', 'page heading matches'
  end

  test "gets privacy policy page" do
    get :privacy
    assert_response :success, 'loaded page with a 200'
    assert_select 'title', 'Privacy Policy - SeatShare', 'title matches expected'
    assert_select 'h1', 'Privacy Policy', 'page heading matches'
  end

  test "gets contact page" do
    get :contact
    assert_response :success, 'loaded page with a 200'
    assert_select 'title', 'Contact - SeatShare', 'title matches expected'
    assert_select 'h1', 'Let\'s talk!', 'page heading matches'
  end


  test "gets teams page" do
    get :teams
    assert_response :success, 'loaded page with a 200'
    assert_select 'title', 'Manage Season Tickets for Your Favorite Team - SeatShare', 'title matches expected'
    assert_select 'h1', 'Take home field advantage', 'page heading matches'
  end

end
