##
# Admin API module
module AdminApi
  ##
  # Version 1
  module V1
    ##
    # Admin API Controller
    class AdminApiController < ApplicationController
      before_action :require_api_key
      respond_to :json

      ##
      # Default view that returns available methods
      def index
        respond_with json_response(
          'methods',
          %w[
            user_count group_count total_invites accepted_invites
            recent_groups recent_users total_tickets tickets_transferred
            tickets_unused
          ]
        )
      end

      ##
      # Returns the user count
      def user_count
        respond_with json_response('user_count', User.active.count)
      end

      ##
      # Returns the group count
      def group_count
        respond_with json_response('group_count', Group.active.count)
      end

      ##
      # Returns the group invitation count
      def total_invites
        since = Time.zone.now - params[:days].to_i.days
        count = GroupInvitation
                .where('created_at > ?', since)
                .count
        respond_with json_response('total_invites', count)
      end

      ##
      # Returns the accepted group invitation count
      def accepted_invites
        since = Time.zone.now - params[:days].to_i.days
        count = GroupInvitation.accepted
                               .where('created_at > ?', since)
                               .count
        respond_with json_response('accepted_invites', count)
      end

      ##
      # Returns a list of recent groups
      def recent_groups
        respond_with json_response(
          'recent_groups',
          Group.all.order('created_at DESC').limit(5)
        )
      end

      ##
      # Returns a list of recent users
      def recent_users
        respond_with json_response(
          'recent_users',
          User.all.order('created_at DESC').first(5)
        )
      end

      ##
      # Returns the total ticket count
      def total_tickets
        respond_with json_response('total_tickets', Ticket.count)
      end

      ##
      # Returns the transferred ticket count
      def tickets_transferred
        if params[:days]
          since = Time.zone.now - params[:days].to_i.days
          tickets = Ticket.where('user_id != owner_id').where('user_id > 0')
                          .joins(:event)
                          .where('start_time > ?', since)
          respond_with json_response('tickets_transferred', tickets.count)
        else
          respond_with json_response(
            'tickets_transferred',
            Ticket.where('user_id != owner_id').where('user_id > 0').count
          )
        end
      end

      ##
      # Returns the unused ticket count
      def tickets_unused
        if params[:days]
          since = Time.zone.now - params[:days].to_i.days
          tickets = Ticket.where('user_id != owner_id').where(user_id: 0)
                          .joins(:event)
                          .where('start_time > ?', since)
          respond_with json_response('tickets_unused', tickets.count)
        else
          respond_with json_response(
            'tickets_unused',
            Ticket.where('user_id != owner_id').where(user_id: 0).count
          )
        end
      end

      private

      ##
      # Wraps the response in a standard structure
      # - method: string of API method
      # - value: string of value
      def json_response(method = '', value = '')
        response = {
          status: 'success',
          version: 1,
          method: method,
          data: value
        }
        response
      end

      ##
      # Validates the API key
      def require_api_key
        api_key = params[:api_key]
        return if api_key == ENV['ADMIN_API_KEY'] && !ENV['ADMIN_API_KEY'].nil?
        response = {
          status: 'error',
          version: 1,
          error: 'Invalid API key'
        }
        respond_with response, status: :forbidden
      end
    end
  end
end
