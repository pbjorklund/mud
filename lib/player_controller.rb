class PlayerController
  attr_accessor :player
  attr_accessor :connection
  attr_accessor :world #Set through MudConnection when starting eventmachine in Server

  def initialize connection
    @connection = connection
  end

  def receive_data data
    data.chomp!

    if player_signed_in?
      @world.command_parser.parse(data, self)
      @connection.send_data player.prompt
    else
      sign_in_player data.gsub(' ','')
    end
  end

  def player_already_signed_in? player_name
    @world.players.any? { |player| player.name == player_name }
  end

  def player_signed_in?
    !@player.nil?
  end

  def sign_in_player player_name
    if player_name.empty?
      send_to_player "You must enter a name\n\nEnter name: " 
    elsif player_already_signed_in? player_name
      send_to_player "That name is already taken. \n\nEnter another name: "
    else
      @player = create_new_player player_name
    end
  end

  def send_data data
    @connection.send_data data
  end

  def disconnect_player
    @world.sign_out_player @player
    @connection.disconnect
  end

  def send_to_player message
    @connection.send_data(message)
  end

  private 

  def create_new_player data
    unless data.empty?
      @player = Player.new(data)
      @world.add_player @player
      @world.broadcast "#{player.name} joined the game!\n"

      [
        "\nWelcome #{@player.name}\n", 
        "Type 'help' for help.\n",
        "---------------------\n",
        player.prompt
      ].each { |message| send_to_player message  }

      player
    end
  end
end
