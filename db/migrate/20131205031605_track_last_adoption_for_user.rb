class TrackLastAdoptionForUser < ActiveRecord::Migration
  def change
    add_column :users, :last_adopt, :datetime
  end
end
