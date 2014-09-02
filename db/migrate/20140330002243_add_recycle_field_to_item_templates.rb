class AddRecycleFieldToItemTemplates < ActiveRecord::Migration
  def change
    add_column :item_templates, :recycle_ingredients, :string
  end
end
