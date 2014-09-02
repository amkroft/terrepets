class AddDescriptionsToItemTrades < ActiveRecord::Migration
  def change
    add_column :item_trades, :description_1, :text
    add_column :item_trades, :description_2, :text
  end
end
