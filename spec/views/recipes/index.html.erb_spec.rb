require 'spec_helper'

describe "recipes/index" do
  before(:each) do
    assign(:recipes, [
      stub_model(Recipe,
        :item_template_id => 1,
        :ingredients => "Ingredients",
        :quantity => 2
      ),
      stub_model(Recipe,
        :item_template_id => 1,
        :ingredients => "Ingredients",
        :quantity => 2
      )
    ])
  end

  it "renders a list of recipes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Ingredients".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
