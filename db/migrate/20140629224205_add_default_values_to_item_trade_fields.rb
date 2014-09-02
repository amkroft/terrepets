class AddDefaultValuesToItemTradeFields < ActiveRecord::Migration
  def change
    change_column :item_trades, :money_1, :integer, null: false, default: 0
    change_column :item_trades, :money_2, :integer, null: false, default: 0
  end
end
