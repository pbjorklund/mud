class Room
  def initialize args={}
    @players = []

    args.each do |k,v| 
      self.instance_variable_set("@#{k}".to_sym, v) 
    end
  end

  def method_missing m
    instance_var = self.instance_variable_get("@#{m.to_s}")
    instance_var ? instance_var : "Room does not have that"
  end

  def add_player player_name
    @players << player_name
  end

  def remove_player player_name
    @players.delete player_name
  end

  def present
    %Q{
\033[32m#{self.name}\033[0m
#{self.description}
Exits: [ #{self.exits.inject("") { |tot, el| el[0] + " " + tot }}]
}
  end
end
