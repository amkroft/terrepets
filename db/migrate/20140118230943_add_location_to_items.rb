class AddLocationToItems < ActiveRecord::Migration
  def change
    add_column :items, :location, :integer, null: false, default: 0
  end
end
