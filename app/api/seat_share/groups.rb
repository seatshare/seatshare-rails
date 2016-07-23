require 'doorkeeper/grape/helpers'

module SeatShare
  ##
  # Public API
  class Groups < API
    resource :groups do
      desc 'List all groups' do
        detail 'Restricted to groups of which authenticated user is a member'\
          ' or administrator.'
      end
      paginate
      get '/' do
        authenticate!
        paginate current_user.groups
      end

      desc 'Return a group.'
      params do
        requires :id, type: Integer, desc: 'Group ID.'
      end
      route_param :id do
        get do
          Group.find(params[:id])
        end
      end

      desc 'Update a group.'
      params do
        requires :id, type: Integer, desc: 'Group ID.'
        requires :name, type: String, desc: 'Group Name.'
      end
      route_param :id do
        put do
          group = Group.find(params[:id])
          raise 'Not an administrator' unless group.admin?(current_user)
          group.update(
            group_name: params[:name]
          )
        end
      end
    end
  end
end
