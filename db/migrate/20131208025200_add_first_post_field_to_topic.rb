class AddFirstPostFieldToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :first_post_id, :integer
  end
end
