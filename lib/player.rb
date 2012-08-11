class Player
  attr_accessor :name
  attr_accessor :prompt

  def initialize name 
    @name = name
    @prompt = " >> "
  end
end
