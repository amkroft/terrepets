class AddFavorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favor, :integer, null: false, default: 0
  end
end
