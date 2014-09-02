class CreatePetBadges < ActiveRecord::Migration
  def change
    create_table :pet_badges do |t|
      t.integer :pet_id, null: false
      t.boolean :master_thief, null: false, default: false
      t.boolean :master_gatherer, null: false, default: false
      t.boolean :master_lumberjack, null: false, default: false
      t.boolean :master_crafter, null: false, default: false
      t.boolean :master_miner, null: false, default: false
      t.boolean :master_fisher, null: false, default: false

      t.timestamps
    end

    Pet.all.each do |pet|
      pet_badge = PetBadge.new(pet_id: pet.id)
      pet_badge.master_thief = pet.master_thief
      pet_badge.master_gatherer = pet.master_gatherer
      pet_badge.master_lumberjack = pet.master_lumberjack
      pet_badge.master_crafter = pet.master_crafter
      pet_badge.master_miner = pet.master_miner
      pet_badge.master_fisher = pet.master_fisher
      pet_badge.save
    end
  end
end
