class AddDurabilityToItemTemplates < ActiveRecord::Migration
  def change
    add_column :item_templates, :durability, :integer
  end
end
