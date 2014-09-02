class CreatePetReincarnations < ActiveRecord::Migration
  def change
    create_table :pet_reincarnations do |t|
      t.integer :pet_id, null: false

      t.datetime :reincarnated_on, null: false
      t.datetime :born_on, null: false
      t.string :masteries, null: false
      t.integer :level, null: false
      t.string :graphic, null: false

      t.datetime :created_at, null: false
    end
  end
end
