class CreateUserStatistics < ActiveRecord::Migration
  def change
    create_table :user_statistics do |t|
      t.integer :user_id, null: false
      t.integer :gifted_items, null: false, default: 0
      t.integer :maze_pieces_placed, null: false, default: 0
      t.integer :hand_fet_pets, null: false, default: 0
      t.integer :money_from_gameselling, null: false, default: 0
      t.integer :items_gamesold, null: false, default: 0
      t.integer :items_recycled, null: false, default: 0
      t.integer :items_received_from_recycling, null: false, default: 0
      t.integer :recipes_made, null: false, default: 0

      t.timestamps
    end
  end
end
