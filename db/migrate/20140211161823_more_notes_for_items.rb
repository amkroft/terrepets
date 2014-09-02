class MoreNotesForItems < ActiveRecord::Migration
  def change
    rename_column :items, :note, :origin_note
    add_column :items, :user_note, :string
  end
end
