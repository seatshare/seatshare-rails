require 'grape-swagger'
require 'doorkeeper/grape/helpers'

# Public API
class API < Grape::API
  version 'v1', using: :path, vendor: 'seatshare'
  prefix :api
  format :json
  helpers Doorkeeper::Grape::Helpers

  before do
    doorkeeper_authorize!
  end

  # API Endpoints
  mount SeatShare::Groups

  # Documentation
  add_swagger_documentation(
    info: {
      title: 'SeatShare API',
      description: 'Public API for SeatShare',
      contact_name: 'SeatShare Support',
      contact_email: 'contact@myseatshare.com',
      contact_url: 'https://myseatshare.com/contact',
      terms_of_service_url: 'https://myseatshare.com/tos'
    },
    add_version: false
  )

  helpers do
    def current_user
      @current_user ||= User.find(doorkeeper_token.resource_owner_id)
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end
  end
end
