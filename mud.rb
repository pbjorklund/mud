Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

server = Server.new
server.start