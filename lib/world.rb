class World
  attr_accessor :players
  attr_reader :command_parser
  attr_reader :server
  attr_reader :rooms

  def initialize server, connections
    @connections = connections
    @server = server
    @players = []
    @command_parser = CommandParser.new self
    @rooms = []
    
    read_rooms_from_file
  end

  def add_player player
    @players.push player
  end

  def sign_out_player player
    player.position.remove_player(player)
    @players.delete player
    broadcast "#{player.name} quit.\n"
  end

  def broadcast message
    @connections.each { |c| c.send_data message }
  end

  def move_player player, direction
    current_room = @rooms.find { |r| r.id == player.position.id }
    new_room = @rooms.find { |r| r.id == current_room.exits[direction.to_s] }
    if new_room != nil
      players_in_room = new_room.players

      came_from = case direction
                  when :north then "south"
                  when :south then "north"
                  when :east then "west"
                  when :west then "east"
                  else "unknown"
                  end

      players_in_room.each { |p| p.controller.send_data "#{player.name} enters from the #{came_from}\n" }
      current_room.remove_player player

      player.position = new_room

      @command_parser.look
    else
      player.controller.send_data "You can't walk #{direction.to_s}\n"
    end
  end

  private
  def read_rooms_from_file
    YAML.load_file("lib/rooms.yml")["rooms"].each do |k,v| 
      @rooms << Room.new(v)
    end
  end
end
