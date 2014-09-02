class AddStarsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :stars, :integer, null: false, default: 0
  end
end
