class MoveEquipmentAssociationToItems < ActiveRecord::Migration
  def change
    remove_column :pets, :equip_id
    add_column :items, :pet_id, :integer
  end
end
