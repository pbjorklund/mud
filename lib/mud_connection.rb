require 'eventmachine'

class MudConnection < EventMachine::Connection
  attr_accessor :player_controller

  def initialize *args
    super
  end

  def post_init
    puts "Connection established"

    send_data "++++++++++++++++++++++++++++++++++\n"
    send_data "+ Welcome to the Darwin Wars Mud +\n"
    send_data "+       A place for growth       +\n"
    send_data "++++++++++++++++++++++++++++++++++\n"
    send_data "\nEnter name: "
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
