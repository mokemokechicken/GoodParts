require "spec_helper"

describe GeneratorController do
  describe "routing" do

    it "routes to #index" do
      get("/generators").should route_to("generators#index")
    end

    it "routes to #new" do
      get("/generators/new").should route_to("generators#new")
    end

    it "routes to #show" do
      get("/generators/1").should route_to("generators#show", :id => "1")
    end

    it "routes to #edit" do
      get("/generators/1/edit").should route_to("generators#edit", :id => "1")
    end

    it "routes to #create" do
      post("/generators").should route_to("generators#create")
    end

    it "routes to #update" do
      put("/generators/1").should route_to("generators#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/generators/1").should route_to("generators#destroy", :id => "1")
    end

  end
end
