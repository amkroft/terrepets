class AddPetsTbl < ActiveRecord::Migration
  def change

  	create_table :pets do |t|
      t.string :name, :null => false
      t.string :birthday, :null => false
      t.boolean :gender, :null => false
      t.integer :user_id, :null =>  false
      

      t.timestamps
     end
  end
end