require 'test_helper'

class GroupFlowTest < ActionDispatch::IntegrationTest
  fixtures :users

  test "create a group" do
    post_via_redirect "/login", {:user => { :email => users(:jim).email, :password => "testing123" }}

    get '/groups/new'
    assert_response :success

    post_via_redirect '/groups/new', {:group => { :group_name => 'A Test Group', :entity_id => '5'}}
    assert_response :success
    assert_select 'title', 'A Test Group'
    assert_equal 'Group created!', flash[:success]
  end

  test "join a group" do
    post_via_redirect "/login", {:user => { :email => users(:jane).email, :password => "testing123" }}

    get '/groups/join'
    assert_response :success

    post_via_redirect '/groups/join', {:group => { :invitation_code => 'ABCDEFG123'}}
    assert_response :success
    assert_equal '/groups/1', path
    assert_equal 'Group joined!', flash[:success]
  end

  test "leave a group" do
    post_via_redirect "/login", {:user => { :email => users(:jill).email, :password => "testing123" }}

    get '/groups/1/leave'
    assert_response :success

    post_via_redirect '/groups/1/leave'
    assert_response :success
    assert_equal '/groups', path
    assert_equal 'You have left Geeks Watching Hockey', flash[:success]
  end

  test "invite a user" do
    post_via_redirect "/login", {:user => { :email => users(:jim).email, :password => "testing123" }}

    get '/groups/1/invite'
    assert_response :success

    post_via_redirect '/groups/1/invite', {:group_invitation => { :email => 'rick@example.net', :message => 'Join us!'}}
    assert_response :success
    assert_equal '/groups/1', path
    assert_equal 'Group invitation sent!', flash[:success]

  end

  test "remove a user from a group" do
    post_via_redirect "/login", {:user => { :email => users(:jim).email, :password => "testing123" }}

    get '/groups/1/edit'
    assert_response :success

    post_via_redirect '/groups/1/leave', {:user_id => 2, :id => 1}
    assert_response :success
    assert_equal '/groups/1/edit', path
    assert_equal 'Jill Smith has been removed', flash[:success]
  end

end
