SeatShare::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, :controllers => {:registrations => "registrations"}, :path => '/', :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'register' }

  root 'public#index'

  get 'teams' => 'public#teams'
  get 'tos' => 'public#tos'
  get 'privacy' => 'public#privacy'
  get 'contact' => 'public#contact'

  devise_scope :user do
    get "register/invite/:invite_code", to: "registrations#new", as: 'register_with_invite_code'
    get "register/:entity_slug/:entity_id", to: "registrations#new", as: 'register_with_entity_id'
  end

  get 'groups/' => 'groups#index'
  get 'groups/new' => 'groups#new', as: 'new_group'
  post 'groups/new' => 'groups#create'
  get 'groups/join' => 'groups#join', as: 'join_group'
  post 'groups/join' => 'groups#do_join'
  get 'groups/:id' => 'groups#show', as: 'group'
  get 'groups/:id/edit' => 'groups#edit', as: 'edit_group'
  patch 'groups/:id/edit' => 'groups#update'
  post 'groups/:id/edit' => 'groups#update'
  get 'groups/:id/leave' => 'groups#leave', as: 'leave_group'
  post 'groups/:id/leave' => 'groups#do_leave'
  get 'groups/:id/invite' => 'groups#invite', as: 'invite_group'
  post 'groups/:id/invite' => 'groups#do_invite'
  post 'groups/:id/reset_invite' => 'groups#do_reset_invite'
  get 'groups/:id/message' => 'groups#message', as: 'message_group'
  post 'groups/:id/message' => 'groups#do_message'
  get 'groups/:id/events_feed' => 'groups#events_feed'

  get 'groups/:group_id/event-:id' => 'events#show'

  get 'groups/:group_id/event-:event_id/ticket-:id' => 'tickets#edit'
  post 'groups/:group_id/event-:event_id/ticket-:id' => 'tickets#update'
  get 'groups/:group_id/event-:event_id/ticket-:id/unassign' => 'tickets#unassign'
  get 'groups/:group_id/event-:event_id/ticket-:id/delete' => 'tickets#delete'
  get 'groups/:group_id/add-tickets' => 'tickets#new'
  post 'groups/:group_id/add-tickets' => 'tickets#create'
  get 'groups/:group_id/event-:event_id/add-ticket' => 'tickets#new'
  post 'groups/:group_id/event-:event_id/add-ticket' => 'tickets#create'
  get 'groups/:group_id/event-:event_id/ticket-:id/request' => 'tickets#request_ticket'
  patch 'groups/:group_id/event-:event_id/ticket-:id/request' => 'tickets#do_request_ticket'

  get 'profiles/:id' => 'profiles#show'
  get 'profile' => 'profiles#edit'
  post 'profile' => 'profiles#update'

  get 'profile/aliases/new' => 'user_aliases#new', as: 'new_user_alias'
  post 'profile/aliases/new' => 'user_aliases#create'
  get 'profile/aliases/:id/edit' => 'user_aliases#edit', as: 'edit_user_alias'
  post 'profile/aliases/:id/edit' => 'user_aliases#update'
  get 'profile/aliases/:id/delete' => 'user_aliases#delete', as: 'delete_user_alias'

end
