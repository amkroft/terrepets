class RenameMailTable < ActiveRecord::Migration
  def change
    rename_table :internal_mail, :internal_mails
  end
end
