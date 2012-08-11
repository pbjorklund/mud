class World
  attr_reader :command_parser
  attr_accessor :players
  attr_reader :server

  def initialize server
    @command_parser = CommandParser.new(self)
    @server = server
    @players = []
  end

  def add_player player
    @players.push player
  end

  def sign_out_player player
    @players.delete player
  end

  def prompt
    ">> "
  end

  def broadcast message
    @server.connections.each { |c| c.send_data message }
  end
end
