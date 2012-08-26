class MudFactory
  def self.room
    Room.new(id: 1000, name: "name", description: "description", exits: {"north"=>1001, "south"=>1002})
  end

  def self.player
    player = Player.new("pbjorklund", {room_id: room.id, hp: 100} )
    player.password = "password"
    player
  end

  def self.second_player
    Player.new("erik", {room_id: room.id} )
  end
end
