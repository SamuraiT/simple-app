require 'pry'
require_relative "config"
require_relative 'controller_helper'
require_relative "app/controller/users_controller"
require_relative "app/controller/blogs_controller"
require_relative "models/users"
require_relative "models/blogs"
require 'socket'
require 'uri'

require_relative 'routes'

server = TCPServer.new(CONFIG[:ipaddress], CONFIG[:port])
puts server

loop do
  session = server.accept
  request = session.gets
  method, path = request.split
  puts "#{method} #{path}"

  controllers = {
    "users" => UsersController.new(session, path),
    "blogs" => BlogsController.new(session, path)
  }

  $route.set_session(session)
  $route.manage(method, path, controllers)

  session.close
end
