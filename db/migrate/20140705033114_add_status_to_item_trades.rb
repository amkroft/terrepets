class AddStatusToItemTrades < ActiveRecord::Migration
  def change
    add_column :item_trades, :status, :integer, null: false, default: 0

    ItemTrade.all.each do |item_trade|
      if item_trade.completed
        item_trade.status = 2 
        item_trade.save
      end
    end

    remove_column :item_trades, :completed
  end
end
