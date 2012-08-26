require 'spec_helper'

#TODO Test it better when we know what it really should do
describe PlayerController do
  let(:connection) { mock.as_null_object }
  let(:world) { MudFactory.world }
  let(:subject) { PlayerController.new connection, world }

  it "sets up a command parsen when created" do
    subject.command_parser.class.should == CommandParser
  end

  it "get's initialized with a world" do
    subject.world.class.should == World
  end

  it "has methods..." do
    [:receive_data, 
     :disconnect_player, 
     :send_data].map { |method| subject.should respond_to method }
  end
end
