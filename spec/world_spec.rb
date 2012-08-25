require 'spec_helper'
require 'world'

describe "World" do

  let(:player) { mock Player }
  let(:server) { mock Server.as_null_object }
  let(:subject) { World.new mock(server), mock }

  it "creates a new global commandparser" do
    subject.command_parser.should_not be_nil
  end

  it "references a server" do
    subject.instance_variable_get(:@server).should_not be_nil
  end

  describe "player handling do" do
    it "is initialized with an empty array of player" do
      subject.players.should == Array.new
    end

    describe "#add_player" do
      it "adds a player given a player" do
        subject.add_player(player)
        subject.players.count.should == 1
      end
    end

    describe "#sign_out_player" do
      it "signs out a player that is loaded" do
        player.stub(:name).and_return("playername")
        player.stub(:position).and_return(MudFactory.room)
        subject.stub(:broadcast).and_return(nil)

        subject.add_player(player)
        subject.sign_out_player(player)
        subject.players.count.should == 0
      end
    end
  end

  describe "#broadcast" do
    it "broadcasts messages to the world" do
      connection = mock
      connection.stub(:send_data).and_return(nil)
      connection.should_receive(:send_data).twice
      subject.instance_variable_set(:@connections, [connection, connection])
      subject.broadcast "message"
    end
  end

  describe "rooms" do
    it "has a representation of the worlds rooms" do
      subject.rooms.should_not be_nil
    end

    it "can't be empty" do
      subject.rooms.count.should > 0
    end
  end

  describe "#move_player" do
    it "moves a player north if possible" do
      player = MudFactory.player
      player.stub(:position).and_return(MudFactory.room)
      controller = mock
      controller.stub(:send_data).and_return(nil)
      player.stub(:controller).and_return(controller)
      subject.instance_variable_set(:@rooms, [MudFactory.room])
      subject.move_player player, :north
    end
    
  end
end

