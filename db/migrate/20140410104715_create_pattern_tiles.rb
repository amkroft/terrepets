class CreatePatternTiles < ActiveRecord::Migration
  def change
    create_table :pattern_tiles do |t|
      t.integer :x, null: false
      t.integer :y, null: false
      t.integer :tile, null: false
      t.integer :treasure_id
      t.integer :obstacle_id

      t.timestamps
    end
  end
end
