class AddTradeNoticeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trade_notice, :boolean, null: false, default: false
  end
end
