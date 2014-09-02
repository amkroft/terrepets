class FixPatternTileField < ActiveRecord::Migration
  def change
    remove_column :pattern_tiles, :tile
    add_column :pattern_tiles, :tile, :string, null: false
    PatternTile.update_all(tile: '1111')
  end
end
