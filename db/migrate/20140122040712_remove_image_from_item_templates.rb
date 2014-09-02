class RemoveImageFromItemTemplates < ActiveRecord::Migration
  def change
    remove_column :item_templates, :image
  end
end
