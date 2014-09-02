class CreateUserBadges < ActiveRecord::Migration
  def change
    create_table :user_badges do |t|
      t.integer :user_id, null: false

      t.boolean :raining_garlic, null: false, default: false
      t.boolean :raining_bacon, null: false, default: false
      t.boolean :baconado, null: false, default: false
      t.boolean :orng, null: false, default: false

      t.column :created_at, :datetime
    end

    User.all.each do |user|
      UserBadge.create(user_id: user.id)
    end
  end
end
