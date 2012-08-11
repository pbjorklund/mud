require 'spec_helper'

describe PlayerController do
  let(:connection) { mock MudConnection }
  let(:subject) { PlayerController.new connection }

  it "has methods..." do
    [:receive_data, 
     :disconnect_player, 
     :create_new_player, 
     :send_data].map { |method| subject.should respond_to method }
  end
end
