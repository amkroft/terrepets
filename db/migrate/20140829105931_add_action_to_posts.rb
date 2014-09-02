class AddActionToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :action, :string
  end
end
