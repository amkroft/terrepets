class ChangeSavingsToZero < ActiveRecord::Migration
  def change
	remove_column :users, :savings
	add_column :users, :savings, :double, :null => false, :default => 0
  end
end
