class ChangeDisplayNameForUsers < ActiveRecord::Migration
  def up
    if User.column_names.include? 'display_name'
      change_column :users, :display_name, :string, :null => false, :unique => true
    else
      add_column :users, :display_name, :string, :null => false, :unique => true
    end
  end

  def down
    change_column :users, :display_name, :string, :null => false
  end
end
