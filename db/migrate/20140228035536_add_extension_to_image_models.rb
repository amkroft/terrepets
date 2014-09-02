class AddExtensionToImageModels < ActiveRecord::Migration
  def change
    add_column :custom_avatars, :extension, :string
    add_column :standard_avatars, :extension, :string
    add_column :custom_pet_templates, :extension, :string
    add_column :standard_pet_templates, :extension, :string
  end
end
