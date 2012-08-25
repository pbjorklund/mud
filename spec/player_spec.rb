require 'spec_helper'

describe Player do
  let(:subject) { MudFactory.player }

  before(:each) do
    Player.any_instance.stub(:player_file).with("test").and_return("spec/players/test.yml")
    Player.any_instance.stub(:player_file).with("testson").and_return("spec/players/testson.yml")
  end

  describe "#prompt" do
    it "returns the users prompt" do
      subject.prompt.should == "HP:100 >> "
    end
  end

  describe "#position" do
    it "has a position" do
      subject.should respond_to(:position)
      subject.should respond_to(:position=)
    end
  end

  describe "#self.create" do
    it "serializes a new player to yaml on disk" do
      player = Player.create "test"
      File.exists?("players/test.yml").should be_true
    end
  end

  describe "#save" do
    it "does not raise errors when saving a valid player" do
      player = Player.new "testson"
      player.password = "testar"
      expect { player.save }.to_not raise_error
    end

    it "raises error when saving an invalid player" do
      player = Player.new "testson"
      expect { player.save }.to raise_error
    end
  end

  describe "#self.load_or_create" do
    it "creates a new player given a name not already saved to disk" do
      Player.should_receive(:create).once
      player = Player.load_or_create "test_create"
    end
    
  end

  describe "#hp" do
    it "has hitpoints" do
      subject.hp.should == 100
    end
  end
end
