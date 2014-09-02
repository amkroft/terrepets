class AddHealthToItems < ActiveRecord::Migration
  def change
    add_column :items, :health, :integer
  end
end
