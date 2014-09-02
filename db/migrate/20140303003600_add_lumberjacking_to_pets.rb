class AddLumberjackingToPets < ActiveRecord::Migration
  def change
    add_column :pets, :lumberjacking, :float, null: false, default: 0.0
  end
end
