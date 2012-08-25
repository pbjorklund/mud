require 'spec_helper'

describe CommandParser do
  let(:world) { mock World }
  let(:commands) { ["exit", "who", "chat"] }
  let(:controller) { mock(PlayerController) }
  let(:subject) { CommandParser.new world }

  before(:each) do
    subject.stub(:send_to_player).and_return(nil)
      controller.stub(:player).and_return(nil)
  end
  describe "#parse" do
    it "parses commands into method calls" do
      controller.stub(:player).and_return(nil)
      subject.should_receive(:exit).once
      subject.parse("exit", controller)
    end

    it "returns an error message for unknown commands" do
      subject.should_receive(:send_to_player).with("unknown is an unknown command.\n").once
      error = subject.parse("unknown", controller) 
    end
  end
end

