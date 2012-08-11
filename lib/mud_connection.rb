require 'eventmachine'

class MudConnection < EventMachine::Connection
  attr_accessor :player_controller

  def initialize *args
    @player_controller = PlayerController.new(self)
    super
  end

  def post_init
    puts "Connection established"

    send_data "Welcome to RMUD. Alpha 0.0.1\n\n"
    send_data "Enter name: "
  end

  def receive_data data
    @player_controller.receive_data data
  end

  def disconnect_player
    close_connection_after_writing
    puts "Connection for #{player} closed."
  end

  def world= world
    @player_controller.world = world
  end

  def player
    @player_controller.player.name
  end
end
