require 'yaml'

class CommandParser
  def initialize world
    @world = world
    @commands = YAML.load_file("lib/commands.yml")
  end

  def parse data, controller
    @controller = controller
    command, message = data.split(' ')
    self.send(command.to_sym, message) if @commands.select { |c| c.match /^#{command}/ } unless command.nil?
  end

  private

  def exit *args
      @controller.disconnect_player
  end

  def chat message=nil
    if message.nil?
      @controller.send_data("Chat what?\n") 
    else
      @world.broadcast "#{@controller.player.name.chomp} chats: #{message}\n"
    end
  end

  def help *args
    @controller.send_data "Known commands:.\n"
    @commands.each { |command| @controller.send_data "#{command}\n" }
  end

  def who *args
    @world.players.each { |p| @controller.send_data( "#{p.name} online.\n") }
  end

  def method_missing method, *args
    @controller.send_to_player "#{method} is an unknown command.\n"
  end
end
