class UpdateSomePetSkills < ActiveRecord::Migration
  def change
    remove_column :pets, :mining
    remove_column :pets, :smithing
    remove_column :pets, :stealth
    remove_column :pets, :fishing

    add_column :pets, :mining, :float, null: false, default: 0.0
    add_column :pets, :smithing, :float, null: false, default: 0.0
    add_column :pets, :stealth, :float, null: false, default: 0.0
    add_column :pets, :fishing, :float, null: false, default: 0.0
  end
end
