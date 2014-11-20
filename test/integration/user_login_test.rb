require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  fixtures :users

  test 'login and view default group' do
    get '/login'
    assert_response :success

    post_via_redirect '/login', user: { email: users(:jim).email, password: 'testing123' }
    assert_equal nil, flash[:alert]
    assert_equal 'Signed in successfully.', flash[:notice]
    assert_equal '/groups/1', path
  end

  test 'login and view group landing page' do
    get '/login'
    assert_response :success

    post_via_redirect '/login', user: { email: users(:sarah).email, password: 'testing123' }
    assert_equal nil, flash[:alert]
    assert_equal 'Signed in successfully.', flash[:notice]
    assert_equal '/groups', path
  end

  test 'login and be denied entry' do
    get '/login'
    assert_response :success

    post_via_redirect '/login', user: { email: users(:peter).email, password: 'testing123' }
    assert_equal 'Your account is not activated yet.', flash[:alert]
    assert_equal '/login', path
  end

  test 'login and then logout' do
    get '/login'
    assert_response :success

    post_via_redirect '/login', user: { email: users(:jim).email, password: 'testing123' }
    assert_equal nil, flash[:alert]
    assert_equal 'Signed in successfully.', flash[:notice]
    assert_equal '/groups/1', path

    delete '/logout'
    assert_equal 'Signed out successfully.', flash[:notice]
    assert_equal '/logout', path

    get '/groups/1'
    assert_equal '/unauthenticated', path
  end
end
