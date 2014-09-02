class AddEquipmentToItemTemplates < ActiveRecord::Migration
  def change
    add_column :item_templates, :is_equipment, :boolean, null: false, default: false
    add_column :item_templates, :equip_crafting, :integer
    add_column :item_templates, :equip_gathering, :integer
    add_column :item_templates, :equip_mining, :integer
    add_column :item_templates, :equip_hunting, :integer
    add_column :item_templates, :equip_smithing, :integer
    add_column :item_templates, :equip_intelligence, :integer
    add_column :item_templates, :equip_dexterity, :integer
    add_column :item_templates, :equip_strength, :integer
    add_column :item_templates, :equip_perception, :integer
    add_column :item_templates, :equip_stamina, :integer
    add_column :item_templates, :equip_athletics, :integer
  end
end
