require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "signup for an account - success" do
    get "/register"
    assert_response :success

    post_via_redirect "/", {:user => { :first_name => 'New', :last_name => 'User', :email => 'newuser@example.com', :password => 'testing123', :password_confirm => 'testing123' }}

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
    assert_equal '/groups', path
  end

  test "signup for an account with an existing email" do
    get "/register"
    assert_response :success

    post_via_redirect "/", {:user => { :first_name => 'New', :last_name => 'User', :email => 'stonej@example.net', :password => 'testing123', :password_confirm => 'testing123' }}

    assert_response :success
    assert_equal 'There were errors with your registration.', flash[:alert]
    assert_equal '/', path
  end

  test "signup for an account with an invite code" do
    get "/register"
    assert_response :success

    post_via_redirect "/", {:user => { :first_name => 'New', :last_name => 'User', :email => 'newuser@example.com', :password => 'testing123', :password_confirm => 'testing123', :invite_code => 'ABCDEFG123' }}

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
    assert_equal '/groups/join', path
  end

  test "signup for an account with an team ID" do
    get "/register"
    assert_response :success

    post_via_redirect "/", {:user => { :first_name => 'New', :last_name => 'User', :email => 'newuser@example.com', :password => 'testing123', :password_confirm => 'testing123', :entity_id => 1 }}

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
    assert_equal '/groups/new', path
  end

end