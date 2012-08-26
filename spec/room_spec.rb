require 'spec_helper'

describe Room do
  let(:subject) { MudFactory.room } 

  it "has a name" do
    subject.name.should eq("name")
  end

  it "has a description" do
    subject.description.should eq "description"
  end

  it "let's us know when we try to call something that it doesn't respond to" do
    subject.non_existant_method.should == "Room does not have that"
  end

  it "has exits" do
    subject.exits.should == {"north"=>1001, "south"=>1002}
  end

  it "can add a player to the room" do
    subject.add_player MudFactory.player
    subject.players.count.should == 1
  end

  it "can remove a player from the room" do
    player = MudFactory.player
    second_player = MudFactory.second_player

    subject.add_player player.name
    subject.add_player second_player.name

    subject.remove_player player.name
    subject.players.count.should == 1
  end
end
