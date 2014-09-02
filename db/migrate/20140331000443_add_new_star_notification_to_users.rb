class AddNewStarNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_new_stars, :boolean, null: false, default: false
  end
end
