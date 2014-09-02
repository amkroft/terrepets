class Topic < ActiveRecord::Base
	belongs_to :forum  
	has_many :posts, :dependent => :destroy
	belongs_to :user 

  self.per_page = 20

  def first_post
    posts=Post.where(:topic_id=>id)
    posts = posts.to_a.sort!{|post1, post2 | post1.created_at <=> post2.created_at}
    posts.first
  end
end
