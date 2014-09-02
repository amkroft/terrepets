class StoreTransaction < ActiveRecord::Base

  belongs_to :user

  self.per_page = 50

end
