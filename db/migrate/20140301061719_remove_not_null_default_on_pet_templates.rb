class RemoveNotNullDefaultOnPetTemplates < ActiveRecord::Migration
  def change
    change_column :custom_pet_templates, :image, :string, null: true
    change_column :standard_pet_templates, :image, :string, null: true
  end
end
