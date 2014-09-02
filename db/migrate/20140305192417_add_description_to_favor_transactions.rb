class AddDescriptionToFavorTransactions < ActiveRecord::Migration
  def change
    add_column :favor_transactions, :description, :string
  end
end
