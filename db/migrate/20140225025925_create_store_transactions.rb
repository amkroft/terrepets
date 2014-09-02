class CreateStoreTransactions < ActiveRecord::Migration
  def change
    create_table :store_transactions do |t|
      t.integer :user_id
      t.string :description
      t.integer :amount

      t.timestamps
    end
  end
end
