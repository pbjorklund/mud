class World
  attr_accessor :player_controllers
  attr_reader :rooms

  def initialize
    @player_controllers = []
    @rooms = read_rooms_from_file
  end

  def add_player_controller player_controller
    @player_controllers << player_controller
  end

  def find_room room_id
    @rooms.select { |r| r.id == room_id }.first
  end

  def broadcast message
    @player_controllers.each { |pc| pc.connection.send_data "\n[World] " + message + "\n" }
  end

  def find_player_controller player_name
    @player_controllers.select { |pc| pc.player.name == player_name }.first
  end

  private
  def read_rooms_from_file
    rooms = []
    YAML.load_file("lib/rooms.yml")["rooms"].each do |k,v| 
      rooms << Room.new(v)
    end
    rooms
  end
end
