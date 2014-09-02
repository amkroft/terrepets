class CustomPetTemplate < ActiveRecord::Base

  include Imageable

  has_many :pets, as: :pet_template

  before_destroy :delete_image

  def image_availability
    'custom'
  end

  def image_type
    'pets'
  end

end
