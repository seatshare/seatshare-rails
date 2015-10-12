require 'test_helper'

##
# Registrations controller test
class RegistrationsControllerTest < ActionController::TestCase
  def setup
    @controller = Users::RegistrationsController.new
  end

  test 'get register route' do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    get :new

    assert_response :success
    assert_select 'title', 'Create a SeatShare Account'
    assert_select 'h4', 'Joining a group?', 'invitation code block is empty'
  end

  test 'get register route with invitation code' do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    get :new, invite_code: 'ABCDEFG123'

    assert_response :success
    assert_select 'title', 'Create a SeatShare Account'
    assert_select(
      'h4',
      "You've been invited join a group!",
      'invitation code block appears'
    )
    assert_select 'strong.invite_code', 'ABCDEFG123', 'invitation code appears'
  end

  test 'get register route with group code' do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    get :new, group_code: 'QWERTY1234'

    assert_response :success
    assert_select 'title', 'Create a SeatShare Account'
    assert_select(
      'h4',
      "You've been invited join a group!",
      'invitation code block appears'
    )
    assert_select 'strong.invite_code', 'QWERTY1234', 'invitation code appears'
  end

  test 'get register route with team id' do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    get :new, entity_id: '1', entity_slug: 'nashville-predators-nhl'

    assert_response :success
    assert_select(
      'title',
      'Create a SeatShare Account - Nashville Predators (NHL)'
    )
    assert_select 'h4', 'Create a Nashville Predators group'
  end
end
