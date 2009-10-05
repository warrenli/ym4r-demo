ActionController::Routing::Routes.draw do |map|
  map.resources :locations, :only => [:destroy]
  map.resources :cities, :only => [:index, :create, :show, :update, :destroy]

  map.root :controller => "cities"
end
