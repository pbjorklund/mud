require 'spec_helper'

describe CommandParser do
  let(:world) { mock World }
  let(:commands) { ["exit", "who", "chat"] }
  let(:connection) { mock(MudConnection) }
  let(:subject) { CommandParser.new world }

  describe "#parse" do
    it "parses commands into method calls" do
      subject.should_receive(:exit).once
      subject.parse("exit", connection)
    end

    it "assigns a connection" do
      world.as_null_object
      subject.parse("who", connection)

      subject.instance_variable_get(:@connection).should == connection
    end
  end
end

