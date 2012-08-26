class PlayerController
  attr_accessor :player
  attr_accessor :connection
  attr_accessor :world #Set through MudConnection when starting eventmachine in Server
  attr_accessor :command_parser

  def initialize connection, world
    @world = world

    @connection = connection
    connection.player_controller = self

    @world.add_player_controller self
    @command_parser = CommandParser.new world, self

    @authenticated = false
  end

  def get_current_room_id
    @player.current_room_id
  end

  def move_player direction
    rooms = @world.rooms

    current_room = rooms.find { |r| r.id == get_current_room_id }
    new_room = rooms.find { |r| r.id == current_room.exits[direction.to_s] }

    if new_room != nil
      players_in_room = new_room.players

      came_from = case direction
                  when :north then "south"
                  when :south then "north"
                  when :east then "west"
                  when :west then "east"
                  else "unknown"
                  end

      players_in_room.each do |p| 
        controller = @world.find_player_controller(p)
        controller.send_data "#{@player.name} enters from the #{came_from}\n"
      end

      current_room.remove_player player.name

      player.current_room_id = new_room.id

      @command_parser.look
    else
      player.controller.send_data "You can't walk #{direction.to_s}\n"
    end
  end


  def receive_data data
    data.chomp!

    if @player
      if @player.has_no_password?
        @player.password = data
        add_player_to_world
        return
      end

      if !@authenticted
        if @player.authenticate data
          add_player_to_world
        else
          send_data "Wrong password, try again: "
        end
      else
        parse data
      end
    else
      send_data "Password:"
      load_player data.gsub(' ','')
    end
  end

  def parse data
    @command_parser.parse data
    @connection.send_data player.prompt
  end

  def add_player_to_world
    @authenticted = true

    if player.current_room_id.nil?
      player.current_room_id = @world.rooms.first.id
    else
      @world.find_room(@player.current_room_id).add_player(player.name)
    end

    player.save
    send_successful_login_message
  end

  def load_player player_name
    if player_name.empty?
      send_data "You must enter a name\n\nEnter name: " 
    else
      @player = Player.load_or_create player_name, self
    end
  end

  def send_data data
    @connection.send_data data
  end

  def disconnect_player
    @world.find_room(@player.current_room_id).remove_player(@player.name)
    @player.save
    @world.player_controllers.delete self
    @world.broadcast "#{@player.name} quit.\n"
    @connection.disconnect
  end

  def self.find_player player_name
    @players.select { |p| p.name == player_name }
  end

  def decrease_hp ammount
    @player.hp -= 10
    @player.update_prompt
  end

  def player_alive?
    @player.hp > 0 ? true : false
  end

  private 
  def send_successful_login_message
    @world.broadcast "#{@player.name} joined the game!"

    [ "\nWelcome #{@player.name}\n", 
      "Type 'help' for help.\n",
      "---------------------\n",
      @player.prompt
    ].each { |message| send_data message  }
  end
end

