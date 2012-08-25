require 'spec_helper'

describe Player do
  let(:subject) { Player.new "Nils" }

  describe "#prompt" do
    it "returns the users prompt" do
      subject.prompt.should == " >> "
    end
  end

  describe "#position" do
    it "has a position" do
      subject.should respond_to(:position)
      subject.should respond_to(:position=)
    end
  end
end
