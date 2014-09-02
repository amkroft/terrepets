class AddThievingToPets < ActiveRecord::Migration
  def change
    add_column :pets, :thieving, :float, null: false, default: 0.0
  end
end
