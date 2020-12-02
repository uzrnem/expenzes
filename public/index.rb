require 'socket'
require 'Mysql2'

#my = Mysql.new(hostname, username, password, databasename)
con = Mysql.new('localhost', 'root', 'sb', 'accounts')
class RequestParser
  def parse(request)
    method, path, version = request.lines[0].split

    {
      path: path,
      method: method,
      headers: parse_headers(request)
    }
  end

  def parse_headers(request)
    headers = {}

    request.lines[1..-1].each do |line|
      return headers if line == "\r\n"

      header, value = line.split
      header        = normalize(header)

      headers[header] = value
    end
  end

  def normalize(header)
    header.gsub(":", "").downcase.to_sym
  end
end

class Response
  attr_reader :code

  def initialize(code:, data: "")
    @response =
    "HTTP/1.1 #{code}\r\n" +
    "Content-Length: #{data.size}\r\n" +
    "\r\n" +
    "#{data}\r\n"

    @code = code
  end

  def send(client)
    client.write(@response)
  end
end

class ResponseBuilder
  SERVER_ROOT = "/home/uzrnem/Documents/ruby/app/"

  def prepare(request)
    if request.fetch(:path) == "/"
      respond_with(SERVER_ROOT + "index.html")
    else
      respond_with(SERVER_ROOT + request.fetch(:path))
    end
  end

  def respond_with(path)
    if File.exists?(path)
      send_ok_response(File.binread(path))
    else
      send_file_not_found
    end
  end

  def send_ok_response(data)
    Response.new(code: 200, data: data)
  end

  def send_file_not_found
    Response.new(code: 404)
  end
end

server  = TCPServer.new('localhost', 8080)
#rs = con.query('select * from student')
#rs.each_hash { |h| puts h['name']}
#con.close
loop {
  client  = server.accept
  request = client.readpartial(2048)

  request  = RequestParser.new.parse(request)
  response = ResponseBuilder.new.prepare(request)

  puts "#{client.peeraddr[3]} #{request.fetch(:path)} - #{response.code}"

  response.send(client)
  client.close
}
