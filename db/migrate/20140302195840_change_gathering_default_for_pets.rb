class ChangeGatheringDefaultForPets < ActiveRecord::Migration
  def change
    change_column :pets, :gathering, :integer, null: false, default: 0.0
  end
end
