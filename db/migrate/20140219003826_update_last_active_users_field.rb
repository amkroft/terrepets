class UpdateLastActiveUsersField < ActiveRecord::Migration
  def change
    change_column :users, :last_active, :datetime, :null => true
  end
end
