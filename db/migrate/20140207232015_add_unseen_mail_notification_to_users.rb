class AddUnseenMailNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_unseen_mail, :boolean, null: false, default: true
  end
end
