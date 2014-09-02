class ChangePetBirthdayType < ActiveRecord::Migration
  def up
    change_column :pets, :birthday, :datetime
  end

  def down
    change_column :pets, :birthday, :string
  end
end
