class SetUpdatedAtToNotNullForItems < ActiveRecord::Migration
  def change
    bad_item_holder = Item.where("updated_at IS NULL AND created_at IS NOT NULL").order("created_at ASC").take
    bad_items_timestamp = bad_item_holder ? bad_item_holder.created_at : Time.now
    Item.where(updated_at: nil).update_all(updated_at: bad_items_timestamp)
    change_column :items, :created_at, :datetime, :null => false
  end
end
