require 'spec_helper'

describe "recipes/new" do
  before(:each) do
    assign(:recipe, stub_model(Recipe,
      :item_template_id => 1,
      :ingredients => "MyString",
      :quantity => 1
    ).as_new_record)
  end

  it "renders new recipe form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", recipes_path, "post" do
      assert_select "input#recipe_item_template_id[name=?]", "recipe[item_template_id]"
      assert_select "input#recipe_ingredients[name=?]", "recipe[ingredients]"
      assert_select "input#recipe_quantity[name=?]", "recipe[quantity]"
    end
  end
end
