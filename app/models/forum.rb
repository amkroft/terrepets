class Forum < ActiveRecord::Base
	has_many :topics, :dependent => :destroy

  @@_city_hall_forum = nil

  def most_recent_topic
    topic = Topic.where('forum_id = ?', self.id).order('last_post_at DESC').first
    return topic  
  end

  def self.city_hall_forum_id
    @@_city_hall_forum ||= Forum.where(name: 'City Hall').pluck(:id).first
    @@_city_hall_forum
  end
  
end
