class AddCityHallNoticeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city_hall_notice, :boolean, null: false, default: false
  end
end
