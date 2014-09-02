class Post < ActiveRecord::Base
	belongs_to :topic
	belongs_to :user 

  self.per_page = 10
end
