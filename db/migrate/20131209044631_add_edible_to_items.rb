class AddEdibleToItems < ActiveRecord::Migration
  def change
    add_column :item_templates, :edible, :boolean, :null => false, :default => false
    add_column :item_templates, :edible_size, :integer
  end
end
