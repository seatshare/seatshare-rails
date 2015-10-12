SeatShare::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, controllers: {
    registrations:  'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, path: '/', path_names: {
    sign_in: 'login', sign_out: 'logout', sign_up: 'register'
  }

  root 'public#index'

  get 'teams' => 'public#teams'
  get 'teams/:entity_type_abbreviation' => 'public#league', as: 'league'
  get 'tos' => 'public#tos'
  get 'privacy' => 'public#privacy'
  get 'contact' => 'public#contact'
  post 'contact' => 'public#do_contact'

  devise_scope :user do
    get "register/group/:group_code", to: "users/registrations#new", as: 'register_with_group_code'
    get "register/invite/:invite_code", to: "users/registrations#new", as: 'register_with_invite_code'
    get "register/:entity_slug/:entity_id", to: "users/registrations#new", as: 'register_with_entity_id'
  end

  get 'groups/' => 'groups#index'
  get 'groups/new' => 'groups#new', as: 'new_group'
  post 'groups/new' => 'groups#create'
  get 'groups/join' => 'groups#join', as: 'join_group'
  post 'groups/join' => 'groups#do_join'
  get 'groups/join/:invite_code' => 'groups#join'
  get 'groups/:id' => 'groups#show', as: 'group'
  get 'groups/:id/edit' => 'groups#edit', as: 'edit_group'
  patch 'groups/:id/edit' => 'groups#update'
  post 'groups/:id/notifications/edit' => 'groups#update_notifications'
  get 'groups/:id/leave' => 'groups#leave', as: 'leave_group'
  patch 'groups/:id/leave' => 'groups#do_leave'
  get 'groups/:id/invite' => 'groups#invite', as: 'invite_group'
  post 'groups/:id/invite' => 'groups#do_invite'
  post 'groups/:id/reset_invite' => 'groups#do_reset_invite'
  get 'groups/:id/deactivate' => 'groups#deactivate', as: 'deactivate_group'
  patch 'groups/:id/deactivate' => 'groups#do_deactivate'
  get 'groups/:id/message' => 'groups#message', as: 'message_group'
  post 'groups/:id/message' => 'groups#do_message'
  get 'groups/:id/events_feed' => 'groups#events_feed'

  get 'groups/:group_id/event-:id' => 'events#show'

  get 'groups/:group_id/event-:event_id/ticket-:id' => 'tickets#edit'
  post 'groups/:group_id/event-:event_id/ticket-:id' => 'tickets#update'
  get 'groups/:group_id/event-:event_id/ticket-:id/unassign' => 'tickets#unassign'
  get 'groups/:group_id/event-:event_id/ticket-:id/delete' => 'tickets#delete'
  get 'groups/:group_id/event-:event_id/ticket-:ticket_id/ticket-file/:id/delete' => 'tickets#delete_ticket_file', as: 'delete_ticket_file'
  get 'groups/:group_id/add-tickets' => 'tickets#new'
  post 'groups/:group_id/add-tickets' => 'tickets#create'
  get 'groups/:group_id/event-:event_id/add-ticket' => 'tickets#new'
  post 'groups/:group_id/event-:event_id/add-ticket' => 'tickets#create'
  get 'groups/:group_id/event-:event_id/ticket-:id/request' => 'tickets#request_ticket'
  patch 'groups/:group_id/event-:event_id/ticket-:id/request' => 'tickets#do_request_ticket'

  get 'tickets' => 'tickets#index'
  get 'tickets/:filter' => 'tickets#index'
  post 'tickets' => 'tickets#bulk_update'

  get 'calendar' => 'calendar#index'
  get 'calendar/full/:token' => 'calendar#full'
  get 'groups/:group_id/calendar/:token' => 'calendar#group'

  resource :user, path: 'profile', only: [:show, :edit, :update] do
    resources :aliases, controller: :user_aliases
  end
  resources :users, path: 'profiles', only: [:show]

  match '/404' => 'errors#error404', via: [:get, :post, :patch, :delete]

  namespace :admin_api, defaults: {format: 'json'} do
    namespace :v1 do
      root 'admin_api#index'
      get ':action' => 'admin_api#:action'
    end
  end

end
