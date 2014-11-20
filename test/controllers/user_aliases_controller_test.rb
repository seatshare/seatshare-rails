require 'test_helper'

class UserAliasesControllerTest < ActionController::TestCase
  test 'should get redirected' do
    get :new

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test 'should get redirected if not owned by user' do
    @user = User.find(1)
    sign_in :user, @user

    get :edit, id: 1

    assert_response :redirect
    assert_redirected_to '/profile'
  end

  test 'should get add' do
    @user = User.find(1)
    sign_in :user, @user

    get :new

    assert_response :success
    assert_select 'title', 'Add User Alias'
  end

  test 'should get edit' do
    @user = User.find(4)
    sign_in :user, @user

    get :edit, id: 1

    assert_response :success
    assert_select 'title', 'Edit User Alias'
  end

  test 'should get delete' do
    @user = User.find(1)
    sign_in :user, @user

    get :delete, id: 1

    assert_response :redirect
    assert_redirected_to '/profile'
  end
end
