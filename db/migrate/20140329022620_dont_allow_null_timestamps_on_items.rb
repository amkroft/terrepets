class DontAllowNullTimestampsOnItems < ActiveRecord::Migration
  def change
    # Set created_at for items without one
    bad_item_holder = Item.where("created_at IS NULL AND updated_at IS NOT NULL").order("updated_at ASC").take
    bad_items_timestamp = bad_item_holder ? bad_item_holder.updated_at : Time.now
    Item.where(created_at: nil).update_all(created_at: bad_items_timestamp)
    Item.where(updated_at: nil).update_all(updated_at: bad_items_timestamp)
    change_column :items, :created_at, :datetime, :null => false

    # Fix bad equipment
    equipment = ItemTemplate.where(is_equipment: true)
    equipment.each do |equip|
      Item.where(health: nil, item_template_id: equip.id).update_all("health = #{equip.durability}")
    end
  end
end
