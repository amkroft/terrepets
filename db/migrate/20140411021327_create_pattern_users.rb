class CreatePatternUsers < ActiveRecord::Migration
  def change
    create_table :pattern_users do |t|
      t.integer :user_id
      t.integer :x
      t.integer :y
    end
  end
end
