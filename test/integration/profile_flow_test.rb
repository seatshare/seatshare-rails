require 'test_helper'

class ProfileFlowTest < ActionDispatch::IntegrationTest
  fixtures :users, :profiles

  test "edit user profile" do
    post_via_redirect "/login", {:user => { :email => users(:jim).email, :password => "testing123" }}

    get '/profile'
    assert_response :success

    post_via_redirect '/profile', {:user => { :first_name => 'Jim', :last_name => 'Stone', :bio => 'Something else entirely.', :location => 'Somewhere Else', :mobile => '(555) 555-4567'}}
    assert_response :success
    assert_select 'title', 'Jim Stone'
    assert_equal 'Profile updated!', flash[:notice]
    assert_select '.profile-email', 'stonej@example.net'
    assert_select '.profile-joined', "Joined #{Date.today.strftime('%B %-d, %Y')}"
    assert_select '.profile-mobile', '555-555-4567'
  end

  test "view edit user without profile" do
    post_via_redirect "/login", {:user => { :email => users(:rick).email, :password => "testing123" }}

    get '/profile'
    assert_response :success

    assert_equal users(:rick).profile.nil?, false
  end

end