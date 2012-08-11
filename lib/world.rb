class World
  attr_reader :command_parser
  attr_accessor :players

  def initialize command_parser
    @command_parser = command_parser
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

  def tick
    
  end
end
