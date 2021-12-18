require_relative 'route_helper'

$route = Routes.new

get  '/', to: "users#index", route: $route
get  '/users/new', to: "users#new", route: $route
post '/users/create', to: "users#create", route: $route
get  /users\/\w*/, to: "users#show", route: $route
get  '/blogs/', to: "blogs#index", route: $route
get  /blogs\/\w*/, to: "blogs#show", route: $route
get  /blogs\/\w*\/publish/, to: "blogs#publish", route: $route
get  '/blogs/new', to: "blogs#new", route: $route
get  '/blogs/create', to: "blogs#create", route: $route
