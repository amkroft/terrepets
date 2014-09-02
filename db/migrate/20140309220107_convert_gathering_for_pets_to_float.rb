class ConvertGatheringForPetsToFloat < ActiveRecord::Migration
  def change
    change_column :pets, :gathering, :float, null: false, default: 0.0
  end
end
