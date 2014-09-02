class AddStarsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stars, :integer, null: false, default: 0
  end
end
