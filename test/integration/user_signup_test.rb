require 'test_helper'

##
# User Signup test
class UserSignupTest < ActionDispatch::IntegrationTest
  test 'signup for an account - success' do
    stub_request(:any, /api.mailchimp.com/)

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
    assert_equal '/groups/new', path
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

  test 'signup for an account with a valid invite code' do
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
    assert_equal '/groups/1', path
  end

  test 'signup for an account with a bad invite code' do
    post_via_redirect(
      '/',
      user: {
        first_name: 'New',
        last_name: 'User',
        email: 'newuser@example.com',
        password: 'testing123',
        password_confirm: 'testing123',
        invite_code: 'XYZ890'
      }
    )

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'Welcome! You have signed up successfully.', flash[:notice]
    assert_equal '/groups', path
  end

  test 'signup for an account with a team id' do
    SeatGeek::Connection.client_id = 'a_test_client_id'
    stub_request(
      :get,
      'https://a_test_client_id:@api.seatgeek.com/2/events'\
        '?per_page=500&performers.slug=nashville-predators&venue.id=2195'
    ).to_return(
      status: 200,
      body: File.new(
        'test/fixtures/seatgeek/events-nashville-predators.json'
      ).read
    )
    stub_request(
      :get,
      'https://a_test_client_id:@api.seatgeek.com/2/performers'\
        '?slug=nashville-predators'
    ).to_return(
      status: 200,
      body: File.new(
        'test/fixtures/seatgeek/performers-nashville-predators.json'
      ).read
    )

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
      user_aliases_path,
      user_alias: { first_name: 'New', last_name: 'Alias' }
    )

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'User alias created!', flash[:notice]
    assert_equal edit_user_path, path
  end

  test 'delete user alias' do
    post_via_redirect(
      '/login',
      user: { email: users(:jill).email, password: 'testing123' }
    )

    get edit_user_path
    assert_response :success

    delete_via_redirect user_alias_path(2)

    assert_response :success
    assert_equal nil, flash[:alert]
    assert_equal 'User Alias deleted.', flash[:notice]
    assert_equal edit_user_path, path
  end
end
