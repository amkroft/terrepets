class ChangeUserAvatarFields < ActiveRecord::Migration
  def change
	rename_column :users, :avator_template_id, :avatar_id
	rename_column :users, :avator_template_type, :avatar_type
  end
end
