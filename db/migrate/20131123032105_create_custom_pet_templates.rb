class CreateCustomPetTemplates < ActiveRecord::Migration
  def change
    create_table :custom_pet_templates do |t|
      t.string :name, :null => false
      t.string :image, :null => false
      t.text :description
      t.integer :uploader, :null => false
      t.integer :recipient
      t.string :author, :null => false
      t.string :rights, :null => false, :default => 'reserved'

      t.timestamps
    end
  end
end
