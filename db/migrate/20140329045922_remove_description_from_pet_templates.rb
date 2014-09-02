class RemoveDescriptionFromPetTemplates < ActiveRecord::Migration
  def change
    remove_column :custom_pet_templates, :description
    remove_column :standard_pet_templates, :description
  end
end
