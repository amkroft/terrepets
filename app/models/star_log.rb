class StarLog < ActiveRecord::Base
  belongs_to :post
  belongs_to :user 

  self.per_page = 20

end