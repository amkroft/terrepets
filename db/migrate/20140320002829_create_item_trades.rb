class CreateItemTrades < ActiveRecord::Migration
  def change
    create_table :item_trades do |t|
      t.integer :user_1_id, null: false
      t.integer :user_2_id, null: false

      t.boolean :anonymous, null: false, default: false
      t.boolean :gift, null: false, default: false

      t.boolean :negotiated, null: false, default: false
      t.boolean :completed, null: false, default: false

      t.text :item_1_ids
      t.text :item_2_ids

      t.integer :money_1
      t.integer :money_2

      t.string :message

      t.timestamps
    end
  end
end
