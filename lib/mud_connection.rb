require 'eventmachine'

class MudConnection < EventMachine::Connection
  attr_accessor :player_controller

  def initialize *args
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

  def disconnect
    close_connection_after_writing
    log_to_server "Connection for #{@player_controller.player.name} closed."
  end

  def log_to_server message
    puts message
  end
end
