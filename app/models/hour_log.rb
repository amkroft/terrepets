class HourLog < ActiveRecord::Base

  belongs_to :pet

  self.per_page = 30

end