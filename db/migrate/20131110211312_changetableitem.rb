class Changetableitem < ActiveRecord::Migration
  def change

	rename_table :items_template, :item_templates
  end
end
