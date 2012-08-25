class Player
  attr_accessor :name
  attr_accessor :prompt
  attr_reader :position
  attr_reader :controller

  def initialize name, args={}
    @position = args[:position]
    @controller = args[:controller]
    @name = name
    @prompt = " >> "
  end

  def position= room
    room.add_player(self)
    @position = room
  end
end
