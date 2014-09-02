class AddItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :image
      t.string :type

      t.timestamps
    end
  end
end