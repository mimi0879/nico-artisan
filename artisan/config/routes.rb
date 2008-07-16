ActionController::Routing::Routes.draw do |map|
  map.resources :videos, :collection => { :add => :get } do |video|
    video.resources :chats, :collection => { :search => :get }
    video.resources :arts
  end
  map.resources :chats

  map.resources :arts, :member => { :nicopost => :post }, :has_many => :comments
  map.resources :comments

  map.resources :histories
  map.resources :accounts

  map.open_id_complete 'session', :controller => "session", :action => "create", :requirements => { :method => :get }  
  map.resource :session

  map.root :controller => "home"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
