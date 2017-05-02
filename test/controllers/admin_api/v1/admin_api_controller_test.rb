require 'test_helper'

##
# Admin API module
module AdminApi
  ##
  # Version 1
  module V1
    ##
    # Admin API Controller
    class AdminApiControllerTest < ActionController::TestCase
      include Devise::Test::ControllerHelpers

      def setup
        ENV['ADMIN_API_KEY'] = 'ABCD12345EFG'
      end

      test 'get API index with correct key' do
        get :index, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_response :success
        assert_equal json['version'], 1
        assert_equal json['method'], 'methods'
        assert_equal json['status'], 'success'
        assert_equal json['data'].length, 9
      end

      test 'get API error with incorrect key' do
        get :index, api_key: 'EFGABCD1234', format: 'json'

        json = JSON.parse(@response.body)

        assert_response :forbidden
        assert_equal json['version'], 1
        assert_equal json['status'], 'error'
        assert_equal json['error'], 'Invalid API key'
      end

      test 'get API error with no key established' do
        ENV['ADMIN_API_KEY'] = nil
        get :index, format: 'json'

        json = JSON.parse(@response.body)

        assert_response :forbidden
        assert_equal json['version'], 1
        assert_equal json['status'], 'error'
        assert_equal json['error'], 'Invalid API key'
      end

      test 'get user counts' do
        get :user_count, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'user_count'
        assert_equal json['status'], 'success'
        assert_equal json['data'], 7
      end

      test 'get group counts' do
        get :group_count, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'group_count'
        assert_equal json['status'], 'success'
        assert_equal json['data'], 2
      end

      test 'get total invites' do
        get :total_invites, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'total_invites'
        assert_equal json['status'], 'success'
        assert_equal json['data'], 0
      end

      test 'get accepted invites' do
        get :accepted_invites, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'accepted_invites'
        assert_equal json['status'], 'success'
        assert_equal json['data'], 0
      end

      test 'get recent groups' do
        get :recent_groups, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'recent_groups'
        assert_equal json['status'], 'success'
        assert_equal json['data'].length, 3
      end

      test 'get recent users' do
        get :recent_users, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'recent_users'
        assert_equal json['status'], 'success'
        assert_equal json['data'].length, 5
      end

      test 'get total tickets' do
        get :total_tickets, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'total_tickets'
        assert_equal json['status'], 'success'
        assert_equal json['data'], 9
      end

      test 'get tickets transferred' do
        get :tickets_transferred, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'tickets_transferred'
        assert_equal json['status'], 'success'
        assert_equal json['data'], 2
      end

      # tickets_unused
      test 'get tickets unused' do
        get :tickets_unused, api_key: ENV['ADMIN_API_KEY'], format: 'json'

        json = JSON.parse(@response.body)

        assert_equal json['version'], 1
        assert_equal json['method'], 'tickets_unused'
        assert_equal json['status'], 'success'
        assert_equal json['data'], 2
      end
    end
  end
end
