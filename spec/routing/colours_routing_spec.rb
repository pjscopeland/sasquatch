require "rails_helper"

RSpec.describe ColoursController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/colours").to route_to("colours#index")
    end

    it "routes to #new" do
      expect(:get => "/colours/new").to route_to("colours#new")
    end

    it "routes to #show" do
      expect(:get => "/colours/1").to route_to("colours#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/colours/1/edit").to route_to("colours#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/colours").to route_to("colours#create")
    end

    it "routes to #update" do
      expect(:put => "/colours/1").to route_to("colours#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/colours/1").to route_to("colours#destroy", :id => "1")
    end

  end
end
