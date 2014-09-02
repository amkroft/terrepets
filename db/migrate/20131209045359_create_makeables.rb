class CreateMakeables < ActiveRecord::Migration
  def change
    create_table :makeables do |t|
      t.integer :difficulty, :null => false, :default => 1
      t.integer :item_template_id, :null => false
      t.string :ingredients, :null => false, :default => ''

      t.timestamps
    end
  end
end
