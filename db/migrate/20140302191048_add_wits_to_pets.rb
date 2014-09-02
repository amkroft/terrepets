class AddWitsToPets < ActiveRecord::Migration
  def change
    add_column :pets, :wits, :float, null: false, default: 0.0
  end
end
