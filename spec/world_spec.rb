require 'spec_helper'
require 'world'

describe "World" do

  let(:player) { mock Player }
  let(:server) { mock Server }
  let(:subject) { World.new mock(server) }

  describe "#add_player" do
    it "adds a player given a player" do
      subject.add_player(player)
      subject.players.count.should == 1
    end
  end

  describe "#sign_out_player" do
    it "signs out a player that is loaded" do
      subject.add_player(player)
      subject.sign_out_player(player)
      subject.players.count.should == 0
    end
  end

  describe "#broadcast" do
    it "tells the world to broadcast a message" do
      subject.server.stub(:connections).and_return([])
      subject.broadcast "message"
    end
  end
end

