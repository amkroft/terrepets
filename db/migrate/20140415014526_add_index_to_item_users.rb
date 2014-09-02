class AddIndexToItemUsers < ActiveRecord::Migration
  def change
	add_index(:items, [:user_id, :location])
  end
end
