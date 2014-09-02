class RemoveNullForUserFields < ActiveRecord::Migration
  def up
    change_column_null(:users, :username, true)
    change_column_null(:users, :display_name, true)
  end

  def down
    change_column_null(:users, :username, false)
    change_column_null(:users, :display_name, false)
  end
end
