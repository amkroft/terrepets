class AddLastActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_active, :datetime, null: false
    User.connection.execute("update users set last_active=created_at")
  end
end
