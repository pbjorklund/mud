require 'spec_helper'

describe Player do
  let(:subject) { MudFactory.player }

  before(:each) do
    Player.stub(:player_file).and_return("spec/players/test.yml")
  end

  after(:each) do
    begin
         File.delete("spec/players/test.yml")
    rescue Errno::ENOENT
    end
  end

  describe "#prompt" do
    it "returns the users prompt" do
      subject.prompt.should == "HP:100 >> "
    end

    it "returns the users prompt with current hp" do
      subject.instance_variable_set(:@hp, 50)
      subject.prompt.should == "HP:50 >> "
    end
  end

  describe "#current_room_id" do
    it "has a current_room_id" do
      subject.should respond_to(:current_room_id)
      subject.should respond_to(:current_room_id=)
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
      player = Player.load_or_create "test_create", mock
    end

    describe "#self.load" do
      it "deserializes a player from disk disk" do
        Player.create "test", nil
        a = Player.load("test", mock)
      end
    end

    describe "#self.create" do
      it "serializes a new player to yaml on disk" do
        player = Player.create "test", nil
        File.exists?("spec/players/test.yml").should be_true
      end
    end
  end

  describe "#hp" do
    it "has hitpoints" do
      subject.hp.should == 100
    end
  end
end
