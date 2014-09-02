class AddThievingAndFishingToEquipment < ActiveRecord::Migration
  def change
    add_column :item_templates, :equip_thieving, :integer, null: false, default: 0
    add_column :item_templates, :equip_fishing, :integer, null: false, default: 0
  end
end
