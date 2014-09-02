class House < ActiveRecord::Base

  belongs_to :user

  def self.max_hours
    24
  end

end
