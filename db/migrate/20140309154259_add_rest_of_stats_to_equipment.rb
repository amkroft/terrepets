class AddRestOfStatsToEquipment < ActiveRecord::Migration
  def change
    add_column :item_templates, :equip_stealth, :integer, null: false, default: 0
    add_column :item_templates, :equip_wits, :integer, null: false, default: 0
  end
end
