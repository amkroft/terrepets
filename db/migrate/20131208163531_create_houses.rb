class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.integer :user_id
      t.datetime :last_hour_run, default: Time.now, null: false
      t.integer :current_bulk, default: 0, null: false
      t.integer :max_bulk, default: 100, null: false

      t.timestamps
    end
  end
end
