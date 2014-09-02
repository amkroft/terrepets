class ModifyPetGraphics < ActiveRecord::Migration
  def up
    remove_column :pets, :image
    change_table :pets do |t|
      t.references :pet_template, polymorphic: true
    end
  end

  def down
    remove_column :pets, :pet_template_id
    remove_column :pets, :pet_template_type
    add_column :pets, :image, :string
  end
end
