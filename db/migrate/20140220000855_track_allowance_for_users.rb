class TrackAllowanceForUsers < ActiveRecord::Migration
  def change
    add_column :houses, :allowance_hours, :integer, null: false, default: 0
  end
end
