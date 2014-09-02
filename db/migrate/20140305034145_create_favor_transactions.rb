class CreateFavorTransactions < ActiveRecord::Migration
  def change
    create_table :favor_transactions do |t|
      t.integer :user_id
      t.integer :amount
      t.string :stripe_id

      t.timestamps
    end
  end
end
