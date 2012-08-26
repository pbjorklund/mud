require 'spec_helper'

describe CommandParser do
  let(:world) { mock World.as_null_object }
  let(:player) { mock Player.as_null_object }
  let(:commands) { ["exit", "who", "chat", "help", "kill"] }
  let(:controller) { mock(PlayerController) }
  let(:subject) { CommandParser.new world, controller }

  before(:each) do
    subject.stub(:send_to_player).and_return(nil)
      controller.stub(:player).and_return(nil)
  end
  describe "#parse" do
    it "parses commands into method calls" do
      controller.stub(:player).and_return(nil)
      subject.should_receive(:exit).once
      subject.parse("exit")
    end

    it "returns an error message for unknown commands" do
      subject.should_receive(:send_to_player).with("unknown is an unknown command.").once
      error = subject.parse("unknown") 
    end
  end

  describe "#look" do
    it "presents a room to the player" do
      #TODO This is clearly a painpoint. Fix
      player.should_receive(:current_room_id).once
      room = mock
      room.stub(:present).and_return(nil)
      p = mock.as_null_object
      room.stub(:players).and_return(p)
      world.stub(:find_room).and_return(room)
      world.should_receive(:find_room).once
      subject.instance_variable_set(:@player, player)
      subject.look
    end
  end
end

