require 'yaml'

class CommandParser

  MOVEMENT_COMMANDS = [:north, :south, :east, :west, :n, :s, :e, :w]

  def initialize world, controller
    @player_controller = controller
    @world = world
    @commands = YAML.load_file("lib/commands.yml")
  end

  def parse data
    @player = @player_controller.player
    command, message = data.split(' ', 2)

    command = command.gsub(/[^0-9A-Za-z]/, '') unless command.nil?
    #todo @player.class
    self.send(command.to_sym, message) if @commands["general"].select { |c| c.match /^#{command}/ } unless command.nil?
  end

  def look *args
    room = @world.find_room(@player.current_room_id)
    send_to_player room.present
    send_to_player room.players.select { |p| p != @player.name }.inject("") { |tot,p| tot += p + " stands here.\n" }
  end

  private
  def exit *args
    @player_controller.disconnect_player
  end

  def chat message=nil
    if message.nil?
      send_to_player "Chat what?"
    else
      send_to_world "#{@player.name.chomp} chats: #{message}"
    end
  end

  def help *args
    send_to_player "Known commands:"

    @commands["general"].each do |k,v| 
      send_to_player %Q{--- \033[32m#{@commands["general"][k]["command"].upcase!}\033[0m ---
Usage:       #{@commands["general"][k]["usage"]}
Description: #{@commands["general"][k]["description"]}}
    end

      send_to_player "--- \033[32mMOVEMENT\033[0m ---"
    send_to_player "Use north | south | west | east to move around"
  end

  def who *args
    pcs = @world.player_controllers
    send_to_player "==== Online Players ===="
    pcs.each { |pc| send_to_player "#{pc.player.name}" }
  end

  def consume target
    return send_to_player "Consume who?" if target.nil?
    target_name = @world.find_room(@player.current_room_id).players.select { |p| p == target }.first
    if target_name.nil?
      send_to_player("Noone by that name here") 
    elsif
      target_name == @player.name
      send_to_player("You can't consume your own essence.") 
    else 
      send_to_player("You reach out, consuming some of #{target}'s essence.") 
      target_controller = @world.find_player_controller(target_name)
      target_controller.decrease_hp(rand(6)+(@player.kills.to_i*0.2))
      if target_controller.player_alive?
        target_controller.send_data "\n#{@player.name} consumes some of your essence, you feel weaker.\n"
      else
        send_to_player "#{@player.add_kill target_name}"
        target_controller.send_data "#{@player.name} killed you! YOU ARE DEAD!\n"
        target_controller.send_data "Log in again to keep fighting the darwin wars\n"
        target_controller.player.hp = @player.max_hp
        target_controller.disconnect_player("was consumed by #{@player.name}, growing their power")
      end
    end
  end

  def lick *args
    hp_increase = rand(5..10)
    @player_controller.increase_hp(hp_increase)
  end

  def save *args
    @player.save
    send_to_player "Player saved."
  end

  def method_missing method, *args
    if MOVEMENT_COMMANDS.include? method
      @player_controller.move_player method
    else
      send_to_player "#{method} is an unknown command."
    end
  end

  private

  def send_to_player message
    @player_controller.send_data message + "\n"
  end

  def send_to_world message
    @world.broadcast message + "\n"
  end

  alias :kill :consume
  alias :c :consume
  alias :l :look
end
