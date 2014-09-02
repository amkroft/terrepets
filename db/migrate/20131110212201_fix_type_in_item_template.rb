class FixTypeInItemTemplate < ActiveRecord::Migration
  def change
	rename_column :item_templates, :type, :category
  end
end
