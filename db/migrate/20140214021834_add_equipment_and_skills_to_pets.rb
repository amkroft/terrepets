class AddEquipmentAndSkillsToPets < ActiveRecord::Migration
  def change
    add_column :pets, :equip_id, :integer
    add_column :pets, :mining, :float
    add_column :pets, :smithing, :float
    add_column :pets, :stealth, :float
    add_column :pets, :fishing, :float
  end
end
