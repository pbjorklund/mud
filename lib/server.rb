require 'eventmachine'
require 'pry'

class Server
  attr_reader :connections
  attr_reader :world

  def initialize *args
    @connections = []
    @world = World.new self
  end
    
  def start
    EventMachine::run {  
      EventMachine::start_server("0.0.0.0", 3500, MudConnection) do |connection|
        connection.world = @world
        @connections << connection
      end
    }
  end

  def stop
    EM.stop
  end
end

