module AdminApi
  module V1
    class AdminApiController < ApplicationController
      before_action :require_api_key
      respond_to :json

      def index
        respond_with json_response('methods', ['user_count','group_count','total_invites','accepted_invites','recent_groups', 'recent_users','total_tickets','tickets_transferred','tickets_unused'])
      end

      def user_count
        respond_with json_response('user_count', User.active.count)
      end

      def group_count
        respond_with json_response('group_count', Group.active.count)
      end

      def total_invites
        respond_with json_response('total_invites', GroupInvitation.count)
      end

      def accepted_invites
        respond_with json_response('accepted_invites', GroupInvitation.accepted.count)
      end

      def recent_groups
        respond_with json_response('recent_groups', Group.all.order('created_at DESC').limit(5))
      end

      def recent_users
        respond_with json_response('recent_users', User.all.order('created_at DESC').first(5))
      end

      def total_tickets
        respond_with json_response('total_tickets', Ticket.count)
      end

      def tickets_transferred
        if params[:days]
          since = DateTime.now - params[:days].to_i.days
          tickets = Ticket.where("user_id != owner_id").where("user_id > 0")
          count = 0
          for ticket in tickets
            if ticket.event.start_time > since
              count += 1
            end
          end
          respond_with json_response('tickets_transferred', count)
        else
          respond_with json_response('tickets_transferred', Ticket.where("user_id != owner_id").where("user_id > 0").count)
        end
      end

      def tickets_unused
        if params[:days]
          since = DateTime.now - params[:days].to_i.days
          tickets = Ticket.where("user_id != owner_id").where("user_id = 0")
          count = 0
          for ticket in tickets
            if ticket.event.start_time > since
              count += 1
            end
          end
          respond_with json_response('tickets_unused', count)
        else
          respond_with json_response('tickets_unused', Ticket.where("user_id != owner_id").where("user_id = 0").count)
        end
      end

      private

      def json_response(method, value)
        response = {
          status: "success",
          version: 1,
          method: method,
          data: value
        }
        return response
      end

      def require_api_key
        if !params[:api_key] || params[:api_key] != ENV['ADMIN_API_KEY']
          response = {
            status: "error",
            version: 1,
            error: "Invalid API key"
          }
          respond_with response
        end
      end

    end
  end
end