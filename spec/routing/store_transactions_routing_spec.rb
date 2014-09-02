require "spec_helper"

describe StoreTransactionsController do
  describe "routing" do

    it "routes to #index" do
      get("/store_transactions").should route_to("store_transactions#index")
    end

    it "routes to #new" do
      get("/store_transactions/new").should route_to("store_transactions#new")
    end

    it "routes to #show" do
      get("/store_transactions/1").should route_to("store_transactions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/store_transactions/1/edit").should route_to("store_transactions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/store_transactions").should route_to("store_transactions#create")
    end

    it "routes to #update" do
      put("/store_transactions/1").should route_to("store_transactions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/store_transactions/1").should route_to("store_transactions#destroy", :id => "1")
    end

  end
end
