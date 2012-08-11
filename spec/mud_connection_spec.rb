require 'spec_helper'
require 'pry'
require 'em-spec/rspec'

describe MudConnection do
  include EM::SpecHelper


  describe "#post_init" do
    it "sends a welcome message" do
      em do
        subject = MudConnection.new(1)

        subject.should_receive(:send_data).twice
        subject.post_init

        done
      end
    end
  end

  describe "#receive_data" do
    it "delegates handling of incoming data to PlayerController" do
      em do
        subject = MudConnection.new(1)
        subject.should_receive(:receive_data).once

        pc = mock
        subject.instance_variable_set(:@player_controller, pc )
        pc.as_null_object

        subject.receive_data("username")

        done
      end
      
    end
    
  end
end
