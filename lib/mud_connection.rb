require 'eventmachine'

class MudConnection < EventMachine::Connection
  attr_accessor :world
  attr_accessor :server
  attr_accessor :player

  def initialize *args
    super
  end

  def post_init
    puts "Connection established"
    send_data "Enter name: "
  end

  def receive_data data
    data.chomp!

    if @player == nil 
      @player = Player.new(data)
      world.add_player @player
      send_data "Type 'help' for help.\n"
      send_data "---------------------\n"
      send_data world.prompt
    else 
      world.command_parser.parse(data, self)
      send_data world.prompt
    end
  end

  def disconnect_player
    send_data "#{@player.name} quit.\n"
    @world.sign_out_player @player
    close_connection_after_writing
    binding.pry
    puts "Connection for #{@player ? @player.name : "unknown"} closed."
  end
end
