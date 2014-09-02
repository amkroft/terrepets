class CreateInternalMail < ActiveRecord::Migration
  def change
		create_table :internal_mail do |t|
			t.integer :from_user_id, :null => false
			t.integer :to_user_id, :null => false
			t.boolean :read, :null => false, :default => false
			t.string :subject
			t.text :content
		
			t.timestamps
		end
  end
end
