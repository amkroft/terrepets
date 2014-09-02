class Rename < ActiveRecord::Migration
  def change

	rename_table :items, :items_template

  end
end
