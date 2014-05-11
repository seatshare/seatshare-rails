SeatShare::Application.routes.draw do

  devise_for :users, :path => '', :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'register' }

  root 'public#index'

  get 'tos' => 'public#tos'
  get 'privacy' => 'public#privacy'
  get 'contact' => 'public#contact'

  get 'groups' => 'groups#index'
  get 'groups/new' => 'groups#new'
  post 'groups/new' => 'groups#create'
  get 'groups/join' => 'groups#join'
  post 'groups/join' => 'groups#do_join'
  get 'groups/:id' => 'groups#show'
  get 'groups/:id/edit' => 'groups#edit'
  post 'groups/:id/edit' => 'groups#update'
  get 'groups/:id/leave' => 'groups#leave'
  post 'groups/:id/leave' => 'groups#do_leave'
  get 'groups/:id/invite' => 'groups#invite'
  post 'groups/:id/invite' => 'groups#do_invite'
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

  get 'profiles/:id' => 'profiles#show'
  get 'profile' => 'profiles#edit'
  post 'profile' => 'profiles#update'

  get 'profile/aliases/new' => 'user_aliases#new'
  post 'profile/aliases/new' => 'user_aliases#create'
  get 'profile/aliases/:id/edit' => 'user_aliases#edit'
  post 'profile/aliases/:id/edit' => 'user_aliases#update'
  get 'profile/aliases/:id/delete' => 'user_aliases#delete'

end
