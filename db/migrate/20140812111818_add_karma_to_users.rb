class AddKarmaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :karma, :integer, null: false, default: 0
  end
end
