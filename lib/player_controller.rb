class PlayerController
  attr_accessor :player
  attr_accessor :connection
  attr_accessor :world #Set through MudConnection when starting eventmachine in Server

  def initialize connection
    @connection = connection
  end

  def receive_data data
    data.chomp!

    if @player == nil 
      @player = create_new_player data

      if @player.nil?
        send_to_player "You must enter a name\n\nEnter name: "
      end

    else 
      @world.command_parser.parse(data, self)
      @connection.send_data player.prompt
    end
  end

  def send_data data
    @connection.send_data data
  end

  def disconnect_player
    @world.broadcast "#{@player.name} quit.\n"
    @world.sign_out_player @player

    @connection.disconnect_player
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

  def send_to_player message
    @connection.send_data(message)
  end
end
