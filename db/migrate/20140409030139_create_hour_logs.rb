class CreateHourLogs < ActiveRecord::Migration
  def change
    create_table :hour_logs do |t|
      t.integer :pet_id, null: false
      t.string :description, null: false
      t.boolean :real_time, null: false, default: false
      t.integer :hour, null: false

      t.timestamps
    end

    add_index :hour_logs, :pet_id
  end
end
