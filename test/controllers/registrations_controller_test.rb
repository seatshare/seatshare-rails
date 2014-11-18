require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  test "get register route" do
    @request.env["devise.mapping"] = Devise.mappings[:user]

    get :new

    assert_response :success
    assert_select "title", "Create Your SeatShare Account"
    assert_select "h4", "Joining a group?", 'invitation code block is empty'
  end

  test "get register route with invitation code" do
    @request.env["devise.mapping"] = Devise.mappings[:user]

    get :new, :invite_code => 'ABCDEFG123'

    assert_response :success
    assert_select "title", "Create Your SeatShare Account"
    assert_select "h4", "You've been invited join a group!", 'invitation code block appears'
    assert_select "strong.invite_code", "ABCDEFG123", 'invitation code appears'
  end

  test "get register route with team id" do
    @request.env["devise.mapping"] = Devise.mappings[:user]

    get :new, :entity_id => '1', :entity_slug => 'nashville-predators-nhl'

    assert_response :success
    assert_select "title", "Create Your SeatShare Account - Nashville Predators (NHL)"
    assert_select "h4", "Create a Nashville Predators group"
  end

end
