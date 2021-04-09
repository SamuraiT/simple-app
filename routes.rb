require_relative 'route_helper'

$route = Routes.new

get  '/', to: "users#index", route: $route
get  '/users/new', to: "users#new", route: $route
post '/users/create', to: "users#create", route: $route
get  /users\/\w*/, to: "users#show", route: $route
