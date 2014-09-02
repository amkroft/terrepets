class AddAvatorTypes < ActiveRecord::Migration
  def change
	add_column :users, :avator_template_id, :integer 
	add_column :users, :avator_template_type, :string
  	remove_column :users, :avatar
  end
end
