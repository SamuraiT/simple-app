
class ControllerHelper

  attr_accessor :session, :path
  def initialize(session, path)
    @session = session
    @path = path
  end

  def form_data
    headers = {}
    while line = @session.gets.split(' ', 2)
      break if line[0] == ""
      headers[line[0].chop] = line[1].strip
    end
    string_form_data = @session.read(headers["Content-Length"].to_i)
    _form_data = {}

    string_form_data.split("&").each do |data|
      key, value = data.split("=")
      _form_data[key] = URI.unescape(value)
    end

    return _form_data
  end

  def render(filename, options={}, status=200)
    response_header(status)
    @session.puts File.read("app/views/#{filename}.html") % options
  end

  def render_template(html, options)
    @session.puts html % options
  end

  def response_header(session, status=200)
    @session.puts "HTTP/1.1 #{status}\r"
    @session.puts "Content-Type: text/html\r"
    @session.puts "\r"
  end
end
