require 'yaml'

class CommandParser
  def initialize server
    @server = server
    @commands = YAML.load_file("lib/commands.yml")
    @connection = nil
  end

  def parse data, connection
    @connection = connection

    command, message = data.split(' ')

    self.send(command.to_sym, message) if @commands.select { |c| c.match /^#{command}/ } unless command.nil?
  end

  def exit *args
      @connection.disconnect_player
      @connection.close_connection_after_writing
      puts "Connection for #{@player ? @player : "unknown"} closed."
  end

  def chat message=nil
    if message.nil? 
      @connection.send_data("Chat what?") 
    else
      @server.connections.each { |c| c.send_data "#{@connection.player.name.chomp} chats: #{message}\n#{prompt}" }
    end
  end

  def help *args
    @connection.send_data "Known commands:.\n"
    @commands.each { |command| @connection.send_data "#{command}\n" }
  end

  def who *args
    @connection.world.players.each { |player| @connection.send_data "#{player.name} online.\n" }
    
  end

  def prompt
    ">> "
  end

  def method_missing method, *args
    @connection.send_data "#{method} is an unknown command.\n"
  end
end
