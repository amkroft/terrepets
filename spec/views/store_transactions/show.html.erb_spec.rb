require 'spec_helper'

describe "store_transactions/show" do
  before(:each) do
    @store_transaction = assign(:store_transaction, stub_model(StoreTransaction,
      :user_id => 1,
      :description => "Description",
      :amount => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Description/)
    rendered.should match(/2/)
  end
end
