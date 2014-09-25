require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  fixtures :users

  test "edit a ticket" do
    post_via_redirect "/login", {:user => { :email => users(:jim).email, :password => "testing123" }}

    get '/groups/1/event-4/ticket-1'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues - 326 K 9'

    post_via_redirect '/groups/1/event-4/ticket-1', {:ticket => { :cost => '40.00', :note => 'added a note'}}
    assert_response :success
    assert_equal '/groups/1/event-4', path
    assert_equal 'Ticket updated!', flash[:notice]
  end

  test "request a ticket" do
    post_via_redirect "/login", {:user => { :email => users(:jill).email, :password => "testing123" }}

    get '/groups/1/event-4/ticket-1/request'
    assert_response :success
    assert_select 'title', 'Nashville Predators vs. St. Louis Blues - 326 K 9'

    patch_via_redirect '/groups/1/event-4/ticket-1/request', {:message => { :personalization => 'requesting a ticket'}}
    assert_response :success
    assert_equal '/groups/1/event-4', path
    assert_equal 'Ticket request sent!', flash[:notice]
  end

  test "unassign a ticket" do
    post_via_redirect "/login", {:user => { :email => users(:jim).email, :password => "testing123" }}

    get '/groups/1/event-4/ticket-1/unassign'
    assert_response :redirect
    assert_equal 'Ticket unassigned!', flash[:notice]
  end

  test "delete a ticket" do
    post_via_redirect "/login", {:user => { :email => users(:jim).email, :password => "testing123" }}

    get '/groups/1/event-4/ticket-1/delete'
    assert_response :redirect
    assert_equal 'Ticket deleted!', flash[:notice]
  end

end
