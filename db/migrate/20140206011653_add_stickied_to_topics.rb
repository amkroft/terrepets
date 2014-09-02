class AddStickiedToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :stickied, :boolean, null: false, default: false
  end
end
