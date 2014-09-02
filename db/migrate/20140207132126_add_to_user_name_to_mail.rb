class AddToUserNameToMail < ActiveRecord::Migration
  def change
    add_column :internal_mails, :to_user_name, :string, null: false
  end
end
