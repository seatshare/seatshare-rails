SeatShare::Application.routes.draw do

  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }

  root 'public#index'

  get 'tos' => 'public#tos'
  get 'privacy' => 'public#privacy'
  get 'contact' => 'public#contact'

  get 'groups' => 'groups#index'
  get 'groups/new' => 'groups#new'
  post 'groups/new' => 'groups#create'
  get 'groups/join' => 'groups#join'
  get 'groups/:id' => 'groups#show'
  get 'groups/:id/edit' => 'groups#edit'
  post 'groups/:id/edit' => 'groups#update'
  get 'groups/:id/leave' => 'groups#leave'
  post 'groups/:id/leave' => 'groups#leave'

  get "groups/:group_id/event-:id" => 'events#show'

  get "groups/:group_id/event-:event_id/ticket-:id" => 'tickets#edit'
  post "groups/:group_id/event-:event_id/ticket-:id" => 'tickets#update'

  get 'profiles/:id' => 'profiles#show'
  get 'profile' => 'profiles#edit'
  post 'profile' => 'profile#update'

end
