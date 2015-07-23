require 'test_helper'

##
# Users controller test
class UsersControllerTest < ActionController::TestCase
  test 'should be redirected' do
    get :show, id: 3

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test 'should get profile of another user' do
    @user = User.find(1)
    sign_in :user, @user

    get :show, id: 3

    assert_response :success, 'received 200 status'
    assert_select 'title', 'Rick Taylor', 'page title matches'
    assert_select 'img.img-thumbnail', 1, 'has a gravatar'
    assert_select '.btn.btn-default', 0, 'does not have edit button'
  end

  test 'should get own profile with edit' do
    @user = User.find(1)
    sign_in :user, @user

    get :show, id: 1

    assert_response :success, 'received 200 status'
    assert_select 'title', 'Jim Stone', 'page title matches'
    assert_select 'img.img-thumbnail', 1, 'has a gravatar'
    assert_select '.btn.btn-default', 1
  end

  test 'should get edit' do
    @user = User.find(1)
    sign_in :user, @user

    get :edit

    assert_response :success, 'received 200 status'
    assert_select 'title', 'Edit Profile', 'page title matches'
  end
end
