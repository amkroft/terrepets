class AddUserNameToInternalMails < ActiveRecord::Migration
  def change
    add_column :internal_mails, :from_user_name, :string, null: false
  end
end
