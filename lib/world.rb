class World
  attr_accessor :players
  attr_reader :server

  def initialize server
    @server = server
    @players = []
  end

  def add_player player
    @players.push player
  end

  def sign_out_player player
    @players.delete player
  end

  def broadcast message
    @server.connections.each { |c| c.send_data message }
  end
end
