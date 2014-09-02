class AddStatsToPets < ActiveRecord::Migration
  def change
    add_column :pets, :sleeping, :boolean, :null => false, :default => false
    add_column :pets, :food, :integer, :null => false, :default => 5
    add_column :pets, :energy, :integer, :null => false, :default => 5

    add_column :pets, :stamina, :float, :null => false, :default => 0, :scale => 4
    add_column :pets, :strength, :float, :null => false, :default => 0, :scale => 4
    add_column :pets, :intelligence, :float, :null => false, :default => 0, :scale => 4
    add_column :pets, :dexterity, :float, :null => false, :default => 0, :scale => 4
    add_column :pets, :perception, :float, :null => false, :default => 0, :scale => 4
    add_column :pets, :crafting, :float, :null => false, :default => 0, :scale => 4
    add_column :pets, :gathering, :float, :null => false, :default => 1, :scale => 4
    add_column :pets, :athletics, :float, :null => false, :default => 0, :scale => 4
    add_column :pets, :survival, :float, :null => false, :default => 0, :scale => 4
  end
end
