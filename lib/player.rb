class Player
  attr_accessor :name, :prompt, :controller, :hp
  attr_reader :current_room_id, :authorized

  def initialize name, args={}
    @current_room_id = args[:current_room_id]
    @controller = args[:controller]
    @hp = args[:hp]
    @name = name
    @prompt = "HP:#{@hp} >> "
    @password = nil
  end

  def update_prompt
    @prompt = "HP:#{@hp} >> "
  end

  def current_room_id= room_id
    @controller.world.find_room(room_id.to_i).add_player(self.name)
    @current_room_id = room_id
  end

  def save
    if valid?
      File.open(Player.player_file(name), 'w') { |f| f.write(YAML.dump(self)) }
      self
    else 
      raise "Player is not valid"
    end
    
  end

  def valid?
    val = ![@name.nil?, @password.nil?].include?(true)
  end

  def self.load_or_create name, controller
    if File.exists?(player_file name) 
      load name, controller
    else
      create name, controller
    end
  end

  def self.create name, controller
    new_player = self.new name, { hp: 100, controller: controller }
    File.open(player_file(name), 'w') { |f| f.write(YAML.dump(new_player)) }
    new_player
  end

  def self.load name, controller
    loaded_player = nil
    File.open(player_file(name), 'r') { |f| loaded_player = YAML.load(f) }

    loaded_player.controller = controller
    loaded_player
  end

  def self.player_file name
   "players/#{name}.yml" 
  end

  def has_no_password?
    @password.nil? ? true : false
  end

  def password= password
    @password = password
  end

  def authenticate password
    @password == password
  end
end
