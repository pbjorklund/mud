require 'spec_helper'
require 'world'

describe World do
  describe "player handling do" do
    it "keeps track of playercontrollers" do
      subject.instance_variable_get(:@player_controllers).should_not be_nil
    end

    describe "#add_player_controller" do
      it "adds a player given a player" do
        subject.add_player_controller(mock)
        subject.player_controllers.count.should == 1
      end
    end

    describe "#broadcast" do
      it "broadcasts messages to the world" do
        player_controller = mock
        connection = mock

        player_controller.stub(:connection).and_return(connection)
        connection.should_receive(:send_data).twice

        subject.instance_variable_set(:@player_controllers, [player_controller, player_controller])
        subject.broadcast "message"
      end
    end

    describe "#find_player_controller" do
      it "searches it's playercontrollers" do
        pc = mock.as_null_object
        pc.should_receive(:player).once
        subject.instance_variable_set(:@player_controllers, [pc])
        subject.find_player_controller "player name"
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
  end
end
