class Player
  attr_accessor :name
  attr_accessor :prompt
  attr_reader :position
  attr_accessor :controller
  attr_reader :authorized

  def initialize name, args={}
    @position = args[:position]
    @controller = args[:controller]
    @name = name
    @prompt = " >> "
    @password = nil
  end

  def position= room
    room.add_player(self)
    @position = room
  end

  def self.create name
    new_player = self.new name
    File.open(player_file(name), 'w') { |f| f.write(YAML.dump(new_player)) }
    new_player
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

  def self.load_or_create name
    if find_player name
      loaded_player = nil
      File.open(player_file(name)) { |f| loaded_player = YAML.load(f) }
      loaded_player 
    else
      create name
    end
  end

  def self.player_file name
   "players/#{name}.yml" 
  end

  def self.find_player name
    File.exists?(player_file name)
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
