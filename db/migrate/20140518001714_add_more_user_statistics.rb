class AddMoreUserStatistics < ActiveRecord::Migration
  def change
    add_column :user_statistics, :pattern_obstacles_cleared, :integer, null: false, default: 0
    User.all.each do |user|
      if user.user_statistic
        user.user_statistic.update_attributes(gifted_items: user.gifted_item_total)
      else
        UserStatistic.create(user_id: user.id, gifted_items: user.gifted_item_total)
      end
    end
    remove_column :users, :gifted_item_total
  end
end
