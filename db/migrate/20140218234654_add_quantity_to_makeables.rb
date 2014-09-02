class AddQuantityToMakeables < ActiveRecord::Migration
  def change
    add_column :makeables, :quantity, :integer, null: false, default: 1
  end
end
