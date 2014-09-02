class TrackNewStoreSales < ActiveRecord::Migration
  def change
    add_column :users, :has_new_sales, :boolean, null: false, default: false
  end
end
