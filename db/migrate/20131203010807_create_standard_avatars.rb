class CreateStandardAvatars < ActiveRecord::Migration
  def change
    create_table :standard_avatars do |t|
      t.string :name
      t.string :image
      t.text :rights

      t.timestamps
    end
  end
end
