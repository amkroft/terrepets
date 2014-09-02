class AddFieldsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :article, :string, null: false, default: 'a'
    add_column :locations, :preposition, :string, null: false, default: 'at'
  end
end
