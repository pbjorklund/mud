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
    direction = case direction
                when :n then :north
                when :s then :south
                when :w then :west
                when :e then :east
                else direction
                end

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
        controller.send_data "\n#{@player.name} enters from the #{came_from}\n"
      end

      current_room_players_without_self = current_room.players.select { |p| p != @player.name }
      current_room_players_without_self.each do |p| 
        controller = @world.find_player_controller(p)
        controller.send_data "\n#{@player.name} leaves #{direction}\n"
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

  def disconnect_player message="quit"
    @world.find_room(@player.current_room_id).remove_player(@player.name)
    @player.save
    @world.player_controllers.delete self
    @world.broadcast @player.name + " " + message + ".\n"
    @connection.disconnect
  end

  def self.find_player player_name
    @players.select { |p| p.name == player_name }
  end

  def decrease_hp ammount=10
    @player.hp -= ammount
    #TODO Render better
    send_data @player.prompt
  end

  def increase_hp ammount
    after_ammount = @player.hp + ammount
    if @player.max_hp < after_ammount 
      send_data "\nYou already feel strong enough to keep fighting.\n"
    else
      @player.hp = after_ammount
      send_data "You lick your wounds, restoring some of your essence.\n"
    end
    #TODO Render better
    send_data @player.prompt
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


