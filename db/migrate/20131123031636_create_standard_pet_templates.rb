class CreateStandardPetTemplates < ActiveRecord::Migration
  def change
    create_table :standard_pet_templates do |t|
      t.string :name, :null => false
      t.string :image, :null => false
      t.text :description
      t.text :rights

      t.timestamps
    end
  end
end
