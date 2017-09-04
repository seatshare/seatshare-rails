require 'test_helper'

##
# User Aliases controller test
class UserAliasesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test 'should get redirected' do
    get :new

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test 'should get redirected if not owned by user' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :edit, id: 1

    assert_response :redirect
    assert_redirected_to edit_user_path
  end

  test 'should get add' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :new

    assert_response :success
    assert_select 'title', 'Add User Alias'
  end

  test 'should get edit' do
    @user = User.find(4)
    sign_in @user, scope: :user

    get :edit, id: 1

    assert_response :success
    assert_select 'title', 'Edit User Alias'
  end

  test 'should update' do
    @user = User.find(4)
    sign_in @user, scope: :user

    put :update, {
      id: 1,
      user_alias: {
        first_name: 'Joe',
        last_name: 'Doe'
      }
    }

    assert_response :redirect
    assert_equal flash[:notice], 'User Alias updated!'
  end

  test 'should get destroy' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :destroy, id: 1

    assert_response :redirect
    assert_redirected_to edit_user_path
  end
end
