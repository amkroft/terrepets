class TrackGiftedItemsTotalOnUsers < ActiveRecord::Migration
  def change
    add_column :users, :gifted_item_total, :integer, null: false, default: 0
  end
end
