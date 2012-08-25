require 'yaml'

class CommandParser

  MOVEMENT_COMMANDS = [:north, :south, :east, :west]

  def initialize world
    @world = world
    @commands = YAML.load_file("lib/commands.yml")
  end

  def parse data, controller
    @controller = controller
    @player = controller.player
    command, message = data.split(' ')
    #todo @player.class
    self.send(command.to_sym, message) if @commands["general"].select { |c| c.match /^#{command}/ } unless command.nil?
  end

  def look *args
    room = @player.position

    send_to_player room.present
    send_to_player room.players.select { |p| p.name != @player.name }.inject("") { |tot,p| tot += p.name + " stands here.\n" }
  end

  private

  def exit *args
    @controller.disconnect_player
  end

  def chat message=nil
    if message.nil?
      send_to_player "Chat what?\n"
    else
      send_to_world "#{@player.name.chomp} chats: #{message}\n"
    end
  end

  def help *args
    send_to_player "Known commands:.\n"

    @commands["general"].each do |k,v| 
      send_to_player %Q{--- \033[32m#{@commands["general"][k]["command"].upcase!}\033[0m ---
Usage:       #{@commands["general"][k]["usage"]}
Description: #{@commands["general"][k]["description"]} }
    end
  end

  def who *args
    @world.players.each { |p| send_to_player "#{p.name} online.\n" }
  end


  def method_missing method, *args
    if MOVEMENT_COMMANDS.include?(method)
      a = @world.move_player(@player, method)
    else
      send_to_player "#{method} is an unknown command.\n"
    end
  end

  private

  def send_to_player message
    @controller.send_data message
  end

  def send_to_world message
    @world.broadcast message
  end
end
