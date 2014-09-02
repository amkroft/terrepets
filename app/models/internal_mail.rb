class InternalMail < ActiveRecord::Base
	
  belongs_to :user, primary_key: :to_user_id

end
