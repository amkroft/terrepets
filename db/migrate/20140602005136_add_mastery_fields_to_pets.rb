class AddMasteryFieldsToPets < ActiveRecord::Migration
  def change
    add_column :pets, :master_gatherer, :boolean, null: false, default: false
    add_column :pets, :master_thief, :boolean, null: false, default: false
    add_column :pets, :master_fisher, :boolean, null: false, default: false
    add_column :pets, :master_crafter, :boolean, null: false, default: false
    add_column :pets, :master_lumberjack, :boolean, null: false, default: false
    add_column :pets, :master_miner, :boolean, null: false, default: false
  end
end
