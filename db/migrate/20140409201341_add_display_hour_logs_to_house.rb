class AddDisplayHourLogsToHouse < ActiveRecord::Migration
  def change
    add_column :houses, :display_hour_logs, :boolean, null: false, default: true
  end
end
