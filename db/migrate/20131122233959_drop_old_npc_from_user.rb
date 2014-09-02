class DropOldNpcFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :npc
  end

  def down
    add_column :users, :npc, :boolean
  end
end
