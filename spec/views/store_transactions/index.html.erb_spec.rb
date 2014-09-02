require 'spec_helper'

describe "store_transactions/index" do
  before(:each) do
    assign(:store_transactions, [
      stub_model(StoreTransaction,
        :user_id => 1,
        :description => "Description",
        :amount => 2
      ),
      stub_model(StoreTransaction,
        :user_id => 1,
        :description => "Description",
        :amount => 2
      )
    ])
  end

  it "renders a list of store_transactions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
