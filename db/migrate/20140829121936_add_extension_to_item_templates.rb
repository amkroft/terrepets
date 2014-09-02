class AddExtensionToItemTemplates < ActiveRecord::Migration
  def change
    add_column :item_templates, :extension, :string, null: false, default: '.png'
  end
end
