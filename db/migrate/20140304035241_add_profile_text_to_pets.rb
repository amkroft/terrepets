class AddProfileTextToPets < ActiveRecord::Migration
  def change
    add_column :pets, :profile, :text
  end
end
