class Player
  attr_accessor :name, :controller, :hp, :max_hp, :kills
  attr_writer :prompt
  attr_reader :current_room_id, :authorized

  def initialize name, args={}
    @current_room_id = args[:current_room_id]
    @controller = args[:controller]
    @hp = args[:hp]
    @max_hp = 20
    @name = name
    @password = nil
    @kills = 0
  end

  def add_kill target
    @kills += 1
    save

    case @kills
    when 1 then "As your body consumes #{target} you feels spikes growing from your shoulders."
    when 2 then "As your body consumes #{target} your hands morph into stone."
    when 5 then "As your body consumes #{target} your head stretches out, forming a deadly spike."
    when 10 then "As your body consumes #{target} you start to think, realizing killing is wrong."
    else "You relish the kill, knowing that it will make you stronger."
    end
  end

  def prompt
    @prompt = "Essence:#{@hp.round(0)} Consumed:#{@kills} >> "
  end

  def current_room_id= room_id
    @controller.world.find_room(room_id).add_player(self.name)
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
    new_player = self.new name, { hp: 20, controller: controller }
    File.open(player_file(name), 'w') { |f| f.write(YAML.dump(new_player)) }
    new_player
  end

  def self.load name, controller
    loaded_player = nil
    File.open(player_file(name)) { |f| loaded_player = YAML.load(f) }

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
