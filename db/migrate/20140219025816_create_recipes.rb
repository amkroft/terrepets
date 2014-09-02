class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :item_template_id
      t.string :ingredients
      t.integer :quantity

      t.timestamps
    end
  end
end
