class AddLumberjackingToEquipment < ActiveRecord::Migration
  def change
    add_column :item_templates, :equip_lumberjacking, :integer, null: false, default: 0
  end
end
