require 'test_helper'

##
# User Signup test
class UserSignupTest < ActionDispatch::IntegrationTest
  test 'signup for an account - success' do
    get '/register'
    assert_response :success

    post_via_redirect(
      '/',
      user: {
        first_name: 'New',
        last_name: 'User',
        email: 'newuser@example.com',
        password: 'testing123',
        password_confirm: 'testing123'
      },
      newsletter_signup: '1'
    )

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
    assert_equal '/groups', path
  end

  test 'signup for an account with an existing email' do
    get '/register'
    assert_response :success

    post_via_redirect(
      '/',
      user: {
        first_name: 'New',
        last_name: 'User',
        email: 'stonej@example.net',
        password: 'testing123',
        password_confirm: 'testing123'
      }
    )

    assert_response :success
    assert_equal 'There were errors with your registration.', flash[:alert]
    assert_equal '/', path
  end

  test 'signup for an account with an invite code' do
    get '/register/invite/ABCDEFG123'
    assert_response :success
    assert_select 'h4', "You've been invited join a group!"

    post_via_redirect(
      '/',
      user: {
        first_name: 'New',
        last_name: 'User',
        email: 'newuser@example.com',
        password: 'testing123',
        password_confirm: 'testing123',
        invite_code: 'ABCDEFG123'
      }
    )

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
    assert_equal '/groups/join', path
  end

  test 'signup for an account with an team ID' do
    get '/register/nashville-predators-nhl/1'
    assert_response :success
    assert_select 'h4', 'Create a Nashville Predators group'

    post_via_redirect(
      '/',
      user: {
        first_name: 'New',
        last_name: 'User',
        email: 'newuser@example.com',
        password: 'testing123',
        password_confirm: 'testing123',
        entity_id: 1
      }
    )

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
    assert_equal '/groups/new', path
  end

  test 'add user alias' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/profile/aliases/new'
    assert_response :success

    post_via_redirect(
      '/profile/aliases/new',
      user_alias: { first_name: 'New', last_name: 'Alias' }
    )

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'User alias created!', flash[:notice]
    assert_equal '/profile', path
  end

  test 'delete user alias' do
    post_via_redirect(
      '/login',
      user: { email: users(:jill).email, password: 'testing123' }
    )

    get '/profile'
    assert_response :success

    get_via_redirect '/profile/aliases/2/delete'

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'User Alias deleted.', flash[:notice]
    assert_equal '/profile', path
  end
end
