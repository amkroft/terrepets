class AddNpcToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_npc, :boolean, :default => false, :null => false
  end
end
