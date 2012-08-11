require 'spec_helper'
require 'pry'

describe Server do
  before(:each) do
      Thread.new { subject.start }
      sleep 0.1 until EM.reactor_running?
  end

  after :each do
    subject.stop
  end

  describe "when started" do
    it "accepts connections on port 3500" do
      lambda { TCPSocket.new "localhost", 3500 }.should_not raise_error
    end
  end
end
