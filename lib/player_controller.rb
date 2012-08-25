class PlayerController
  attr_accessor :player
  attr_accessor :connection
  attr_accessor :world #Set through MudConnection when starting eventmachine in Server

  def initialize connection
    @connection = connection
    @authenticated = false
  end

  def receive_data data
    data.chomp!

    if @player
      if @player.valid?
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
    @world.command_parser.parse(data, self)
    @connection.send_data player.prompt
  end

  def add_player_to_world
    @authenticted = true
    @player.controller = self
    @world.add_player @player

    player.position = @world.rooms.first if player.position.nil?
    player.save
    send_successful_login_message
  end

  def load_player player_name
    if player_name.empty?
      send_data "You must enter a name\n\nEnter name: " 
    else
      @player = Player.load_or_create(player_name)
    end
  end

  def send_data data
    @connection.send_data data
  end

  def disconnect_player
    @player.save
    @world.sign_out_player @player
    @connection.disconnect
  end

  private 
  def send_successful_login_message
    @world.broadcast "#{@player.name} joined the game!\n"

    [ "\nWelcome #{@player.name}\n", 
      "Type 'help' for help.\n",
      "---------------------\n",
      @player.prompt
    ].each { |message| send_data message  }
  end
end
