require 'spec_helper'

describe "StoreTransactions" do
  describe "GET /store_transactions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get store_transactions_path
      response.status.should be(200)
    end
  end
end
