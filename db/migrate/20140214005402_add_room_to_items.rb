class AddRoomToItems < ActiveRecord::Migration
  def change
    add_column :items, :room, :integer, null: false, default: 0
  end
end
