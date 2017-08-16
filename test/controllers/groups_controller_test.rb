require 'test_helper'

##
# Groups controller test
class GroupsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test 'should be redirected' do
    get :index

    assert_response :redirect
    assert_redirected_to '/login'
  end

  test 'should get index' do
    @user = User.find(2)
    sign_in @user, scope: :user

    get :index
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Groups', 'page title matches'
    assert_select '.group_name', 2, 'page shows correct count of joined groups'
  end

  test 'should see group creation page' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :new
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Create a Group', 'page title matches'
    assert_select(
      "form select[name='group[entity_id]'] option",
      6,
      'select on page has six items'
    )
  end

  test 'should see join page' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :join
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Join a Group', 'page title matches'
  end

  test 'should see join page with pre-populated code' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :join, invite_code: 'ABC123'
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Join a Group', 'page title matches'
    assert_select 'input[id="group_invitation_code"]'
    assert_select 'input[value="ABC123"]'
  end

  test 'should see invite page' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :invite, id: 2
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Invite Member to Nashville Fans of Ballsports'
  end

  test 'should see leave page' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :leave, id: 2
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Leave Nashville Fans of Ballsports'
  end

  test 'should see deactivate page' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :deactivate, id: 1
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Deactivate Geeks Watching Hockey'
  end

  test 'should get group page' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :show, id: 1
    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Geeks Watching Hockey', 'page title matches'
  end

  test 'non-member should get redirected to groups index' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :show, id: 2
    assert_response :redirect, 'was redirected to groups listing'
    assert_redirected_to controller: 'groups', action: 'index'
  end

  test 'should see remove user option' do
    @user = User.find(1)
    sign_in @user, scope: :user

    get :edit, id: 1
    assert_response :success, 'got a 200 status'
    remove_user_column = css_select('.remove-user')
    assert remove_user_column, 'Remove User'
  end

  test 'should not see remove user option' do
    @user = User.find(2)
    sign_in @user, scope: :user

    get :edit, id: 1
    remove_user_column = css_select('.remove-user')
    !assert remove_user_column, 'Remove User'
    assert remove_user_column.length, 0
  end

  test 'should remove user - admin' do
    @user = User.find(1)
    @removed = User.find(2)
    @group = Group.find(1)
    sign_in @user, scope: :user

    post :do_leave, user_id: @removed, id: @group.id
    assert_response :redirect, 'got a 304 status'
    assert_equal flash[:notice], 'Jill Smith has been removed'
  end

  test 'should remove user - not admin' do
    @user = User.find(3)
    @removed = User.find(3)
    @group = Group.find(1)
    sign_in @user, scope: :user

    post :do_leave, user_id: @removed, id: @group.id
    assert_response :redirect, 'got a 304 status'
    assert_equal flash[:notice], 'You have left Geeks Watching Hockey'
  end

  test 'should not remove user - administrator' do
    assert_raise RuntimeError do
      @user = User.find(1)
      @removed = User.find(1)
      @group = Group.find(1)
      sign_in @user, scope: :user

      post :do_leave, user_id: @removed, id: @group.id
    end
  end

  test 'should not remove user - insufficient permission' do
    @user = User.find(3)
    @removed = User.find(2)
    @group = Group.find(1)
    sign_in @user, scope: :user

    post :do_leave, user_id: @removed, id: @group.id
    assert_response :redirect, 'got a 304 status'
    assert_equal(
      flash[:error],
      'You do not have permission to remove other users.'
    )
  end

  test 'should see group message window' do
    @user = User.find(1)
    @group = Group.find(1)

    sign_in @user, scope: :user

    get :message,  id: @group.id

    assert_response :success, 'got a 200 status'
    assert_select 'title', 'Send a Group Message to Geeks Watching Hockey'
  end

  test 'should get events feed' do
    @user = User.find(1)
    @group = Group.find(1)

    sign_in @user, scope: :user

    get :events_feed,  id: @group.id
    events = JSON.parse(response.body)

    assert_response :success
    assert_equal 7, events.length
    assert_equal(
      '8:00 pm CDT - Nashville Predators vs. Minnesota Wild',
      events[0]['title']
    )
  end

  test 'should update notification options' do
    @user = User.find(1)
    @group = Group.find(1)

    sign_in @user, scope: :user

    post :update_notifications, {
      id: @group.id, 
      membership: {
        daily_reminder: true,
        weekly_reminder: true,
        mine_only: false
      }
    }

    assert_response :redirect
    assert_equal flash[:notice], 'Reminder settings updated!'
  end

  test 'should send message' do
    @user = User.find(1)
    @group = Group.find(1)

    sign_in @user, scope: :user

    post :do_message, {
      id: @group.id, 
      message: {
        recipients: [1],
        subject: 'Test message subject',
        message: 'Test message body'
      }
    }

    assert_response :redirect
    assert_equal flash[:notice], 'Message sent!'
  end

  test 'should fail to send message' do
    @user = User.find(1)
    @group = Group.find(1)

    sign_in @user, scope: :user

    post :do_message, {
      id: @group.id, 
      message: {
        recipients: [],
        subject: 'Test message subject',
        message: 'Test message body'
      }
    }

    assert_response :redirect
    assert_equal flash[:error], 'You must select at least one recipient.'
  end
  
  test 'should reset invitation code' do
    @user = User.find(1)
    @group = Group.find(1)

    sign_in @user, scope: :user

    post :do_reset_invite, {
      id: @group.id
    }

    assert_response :redirect
    assert_equal flash[:notice], 'Invitation code reset!'
  end

  test 'should deactivate group' do
    @user = User.find(1)
    @group = Group.find(1)

    sign_in @user, scope: :user

    post :do_deactivate, {
      id: @group.id
    }

    assert_response :redirect
    assert_equal flash[:notice], 'Your group has been deactivated!'
  end

  test 'should request notification of new events' do
    @user = User.find(1)
    @group = Group.find(1)

    sign_in @user, scope: :user

    post :do_request_notify, {
      id: @group.id
    }

    assert_response :redirect
    assert_equal flash[:notice], 'Schedule request sent!'
  end
end
