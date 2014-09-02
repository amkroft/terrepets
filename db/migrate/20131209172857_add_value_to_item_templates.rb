class AddValueToItemTemplates < ActiveRecord::Migration
  def change
    add_column :item_templates, :value, :integer, :null => false, :default => 1
  end
end
