class Addnpctousers < ActiveRecord::Migration
  def change

	add_column :users, :npc, :boolean

  end
end
