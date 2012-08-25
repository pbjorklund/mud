class MudFactory
  def self.room
    Room.new(id: 1000, name: "name", description: "description", exits: {"north"=>1001, "south"=>1002})
  end

  def self.player
    Player.new("pbjorklund", {position: room} )
  end

  def self.second_player
    Player.new("erik", {position: room} )
  end
end
