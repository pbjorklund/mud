Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

begin
  server = Server.new
  server.start
rescue
  retry
end
