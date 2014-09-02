require 'spec_helper'

describe "store_transactions/edit" do
  before(:each) do
    @store_transaction = assign(:store_transaction, stub_model(StoreTransaction,
      :user_id => 1,
      :description => "MyString",
      :amount => 1
    ))
  end

  it "renders the edit store_transaction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", store_transaction_path(@store_transaction), "post" do
      assert_select "input#store_transaction_user_id[name=?]", "store_transaction[user_id]"
      assert_select "input#store_transaction_description[name=?]", "store_transaction[description]"
      assert_select "input#store_transaction_amount[name=?]", "store_transaction[amount]"
    end
  end
end
