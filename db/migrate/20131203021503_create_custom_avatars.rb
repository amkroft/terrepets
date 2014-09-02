class CreateCustomAvatars < ActiveRecord::Migration
  def change
    create_table :custom_avatars do |t|
      t.string :name
      t.string :image
      t.integer :uploader
      t.string :author
      t.text :rights

      t.timestamps
    end
  end
end
