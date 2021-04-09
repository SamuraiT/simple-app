require 'pry'

def get(path, to:, route:)
  route["GET"][path] = to
end

def post(path, to:, route:)
  route["POST"][path] = to
end

class Routes

  attr_accessor :routes, :session
  def initialize(session=nil, routes={"GET" => {}, "POST" => {} })
    @routes = routes
    @session = session
  end

  def set_session(session)
    @session = session
  end

  def call_controller_method(method, path, controllers)
    controller_key, controller_method = @routes[method][path].split("#")
    controllers[controller_key].send(controller_method)
  end

  def manage(method, path, controllers)
    if @routes[method][path].nil?
      @routes[method].keys.each do |regex_path|
        next if regex_path.match(path).nil?
        return call_controller_method(method, regex_path, controllers)
      end

      return nil 
    end
    # Procを使っても良い。拡張性のあるコードを実現する際、Procを使うべき
    call_controller_method(method, path, controllers)
  end

  def []=(key, value)
    @routes[key] = value
  end

  def [](key)
    @routes[key]
  end
end


if __FILE__ == $0 
  route = Routes.new("session-dayo")
  def index(session)
    puts "hi", session
  end

  get "/users/index", to: "index", route: route
  route.manage("GET", "/users/index")
end
