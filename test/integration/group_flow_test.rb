require 'test_helper'

class GroupFlowTest < ActionDispatch::IntegrationTest
  fixtures :users

  test "create a group" do
    post_via_redirect "/login", {:user => { :email => users(:jim).email, :password => "testing123" }}

    get '/groups/new'
    assert_response :success

    post_via_redirect '/groups/new', {:group => { :group_name => 'A Test Group', :entity_id => '5'}}
    assert_response :success
    assert_equal '/groups/4', path
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

end
