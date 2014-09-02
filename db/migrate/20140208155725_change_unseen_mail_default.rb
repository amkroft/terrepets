class ChangeUnseenMailDefault < ActiveRecord::Migration
  def up
    change_column :users, :has_unseen_mail, :boolean, :default => false
  end

  def down
    change_column :users, :has_unseen_mail, :boolean, :default => true
  end
end
