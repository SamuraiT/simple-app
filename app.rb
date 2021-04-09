require 'pry'
require_relative "config"
require_relative 'controller_helper'
require_relative "app/controller/users_controller"
require_relative "models/users"
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
    "users" => UserController.new(session, path)
  }

  $route.set_session(session)
  $route.manage(method, path, controllers)

  session.close
end
