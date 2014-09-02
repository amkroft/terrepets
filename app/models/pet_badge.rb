class PetBadge < ActiveRecord::Base
  belongs_to :pet

  def badges
    holder = []
    [].each do |badge| # LIST REDACTED
      holder << badge if self.send(badge)
    end
    holder
  end
end