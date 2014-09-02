class StandardAvatar < ActiveRecord::Base

	has_many :users, as: :avatar

  before_destroy :delete_image

  include Imageable

  def image_availability
    'standard'
  end

  def image_type
    'avatars'
  end

end
