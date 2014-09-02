class RemoveOldImageFields < ActiveRecord::Migration
  def change
    remove_column :standard_pet_templates, :image
    remove_column :custom_pet_templates, :image
    remove_column :standard_avatars, :image
    remove_column :custom_avatars, :image
  end
end
