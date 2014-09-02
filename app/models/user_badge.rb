class UserBadge < ActiveRecord::Base

  belongs_to :user

  def badges
    holder = [] # LIST REDACTED
    holder.select { |badge| self.send(badge) }
  end

end