class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, :null => false
      t.integer :level, :null => false, :default => 1
      t.string :prizes, :null => false, :default => ''
      t.string :category, :null => false, :default => 'gathering'

      t.timestamps
    end
  end
end
