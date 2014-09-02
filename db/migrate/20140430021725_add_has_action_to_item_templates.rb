class AddHasActionToItemTemplates < ActiveRecord::Migration
  def change
    add_column :item_templates, :has_action, :boolean, null: false, default: false
  end
end
