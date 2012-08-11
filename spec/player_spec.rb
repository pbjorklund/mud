require 'spec_helper'

describe Player do
  let(:subject) { Player.new "Nils" }

  describe "#prompt" do
    it "returns the users prompt" do
      subject.prompt.should == " >>"
    end
  end
end
