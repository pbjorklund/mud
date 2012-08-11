require 'eventmachine'
require 'pry'

class Server
  attr_reader :connections

  def initialize *args
    @connections = []
    @world = World.new(CommandParser.new(self))
  end
    
  def start
    EventMachine::run {  
      EventMachine::start_server("0.0.0.0", 3500, MudConnection) do |connection|
        connection.server = self
        connection.world = @world
        @connections << connection
      end
    }
  end

  def stop
    EM.stop
  end
end

require_relative 'mud_connection'
