class CreateStarLogs < ActiveRecord::Migration
  def change
    create_table :star_logs do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :author_id
      t.integer :count
      t.boolean :new

      t.timestamps
    end
  end
end
