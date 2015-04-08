require 'test_helper'

##
# Profile Flow test
class UserFlowTest < ActionDispatch::IntegrationTest
  fixtures :users

  test 'edit user profile' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/profile/edit'
    assert_response :success

    patch_via_redirect(
      '/profile',
      user: {
        first_name: 'Jim',
        last_name: 'Stone',
        bio: 'Something else entirely.',
        location: 'Somewhere Else',
        mobile: '(555) 555-4567',
        notify_sms: 1
      }
    )
    assert_response :success
    assert_select 'title', 'Jim Stone'
    assert_equal 'Profile updated!', flash[:notice]
    assert_select '.profile-email', 'stonej@example.net'
    assert_select '.profile-mobile', '(555) 555-4567'
  end

  test 'change email or password' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )

    get '/edit'
    assert_response :success
    assert_select 'legend', 'Your Login'

    put_via_redirect(
      '/',
      user: {
        email: 'some_new_email@example.com',
        current_password: 'testing123'
      }
    )
    assert_response :success
    assert_equal '/groups/1', path
    assert_equal 'You updated your account successfully.', flash[:notice]
  end

  test 'show current user profile' do
    post_via_redirect(
      '/login',
      user: { email: users(:jim).email, password: 'testing123' }
    )
    get '/profile'
    assert_response :success
    assert_select '.profile-email', 'stonej@example.net'
    assert_select '.profile-mobile', '(555) 555-4567'
    assert_select 'title', 'Jim Stone'
  end
end
