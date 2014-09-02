class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null => false, :unique => true
      t.string :password, :null => false
      t.datetime :password_date, :null => false, :default => Time.now
      t.string :display_name, :null => false, :unique => true
      t.string :email, :null => false
      t.boolean :is_admin, :null => false, :default => false
      t.integer :money, :null => false, :default => 500

      t.timestamps
    end
  end
end
