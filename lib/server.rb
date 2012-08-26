require 'eventmachine'
require 'pry'

class Server

  def initialize *args
    @world = World.new 
  end
    
  def start
    EventMachine::run {  
      EventMachine::start_server("0.0.0.0", 3500, MudConnection) do |connection|
        player_controller = PlayerController.new connection, @world
      end
    }
  end

  def stop
    EM.stop
  end
end

