class World
  attr_accessor :players
  attr_reader :command_parser
  attr_reader :server

  def initialize server
    @server = server
    @players = []
    @command_parser = CommandParser.new self
  end

  def add_player player
    @players.push player
  end

  def sign_out_player player
    @players.delete player
    broadcast "#{player.name} quit.\n"
  end

  def broadcast message
    @server.connections.each { |c| c.send_data message }
  end
end
