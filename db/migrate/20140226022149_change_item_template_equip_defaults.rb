class ChangeItemTemplateEquipDefaults < ActiveRecord::Migration
  def change
    ItemTemplate.where(equip_crafting: nil).update_all(equip_crafting: 0)
    change_column :item_templates, :equip_crafting, :integer, default: 0, null: false
    ItemTemplate.where(equip_gathering: nil).update_all(equip_gathering: 0)
    change_column :item_templates, :equip_gathering, :integer, default: 0, null: false
    ItemTemplate.where(equip_mining: nil).update_all(equip_mining: 0)
    change_column :item_templates, :equip_mining, :integer, default: 0, null: false
    ItemTemplate.where(equip_hunting: nil).update_all(equip_hunting: 0)
    change_column :item_templates, :equip_hunting, :integer, default: 0, null: false
    ItemTemplate.where(equip_smithing: nil).update_all(equip_smithing: 0)
    change_column :item_templates, :equip_smithing, :integer, default: 0, null: false
    ItemTemplate.where(equip_intelligence: nil).update_all(equip_intelligence: 0)
    change_column :item_templates, :equip_intelligence, :integer, default: 0, null: false
    ItemTemplate.where(equip_dexterity: nil).update_all(equip_dexterity: 0)
    change_column :item_templates, :equip_dexterity, :integer, default: 0, null: false
    ItemTemplate.where(equip_strength: nil).update_all(equip_strength: 0)
    change_column :item_templates, :equip_strength, :integer, default: 0, null: false
    ItemTemplate.where(equip_perception: nil).update_all(equip_perception: 0)
    change_column :item_templates, :equip_perception, :integer, default: 0, null: false
    ItemTemplate.where(equip_stamina: nil).update_all(equip_stamina: 0)
    change_column :item_templates, :equip_stamina, :integer, default: 0, null: false
    ItemTemplate.where(equip_athletics: nil).update_all(equip_athletics: 0)
    change_column :item_templates, :equip_athletics, :integer, default: 0, null: false
  end
end
