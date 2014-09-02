class PostsController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: :create
  skip_authorize_resource only: [:star, :star_post_ajax]

  # GET /posts
  # GET /posts.json
  def index
    redirect_to forum_topic_path(params[:forum_id], params[:topic_id])
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    index = Post.where(topic_id: @post.topic_id).order('created_at ASC').index(@post)
    page = index/Post.per_page + 1
    url = forum_topic_path(@post.topic.forum_id, @post.topic)
    anchor = "post_#{@post.id}"
    redirect_to "#{url}?page=#{page}##{anchor}"
  end

  # GET /posts/new
  def new
    @post.topic_id = params[:topic_id]
    @topic = Topic.find(params[:topic_id])
    @forum = Forum.find(params[:forum_id])
    @previous_posts = @topic.posts.includes(:user).order('created_at DESC').take(3)
  end

  # GET /posts/1/edit
  def edit
    @topic = Topic.find(params[:topic_id])
    if @topic.first_post_id == @post.id
      redirect_to edit_forum_topic_path(params[:forum_id], @topic.id)
    else
      @forum = Forum.find(params[:forum_id])  
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        topic = Topic.find(params[:topic_id])
        topic.last_post_at = @post.created_at
        topic.last_poster_id = @post.user_id
        topic.save

        format.html { redirect_to post_path(@post), notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post, :user_id => current_user.id }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_path(@post), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to forum_topic_path(params[:forum_id], params[:topic_id]) }
      format.json { head :no_content }
    end
  end

  def star
    if current_user.stars <= 0
      redirect_to forum_topic_path(params[:forum_id],params[:topic_id]), {alert: 'You don\'t have any stars to give.'}
    elsif @post.user_id == current_user.id
      redirect_to forum_topic_path(params[:forum_id],params[:topic_id]), {alert: 'You can\'t star your own posts.'}
    else
      StarLog.transaction do
        current_user.update_attributes(stars: current_user.stars - 1)
        @post.user.update_attributes(has_new_stars: true)
        @post.update_attributes(stars: @post.stars + 1)
        star_log = StarLog.find_by(post_id: @post.id, user_id: current_user.id)
        if star_log
          star_log.update_attributes({count: star_log.count + 1, :new => true})
        else
          StarLog.create({user_id: current_user.id, post_id: @post.id, author_id: @post.user_id, :new => true, count: 1})
        end
      end
      
      redirect_to post_path(@post)
    end
  end

  def star_post_ajax
    if current_user.stars <= 0
      render json: { error: true, error_message: "You don\'t have any stars to give." }, status: 403
    elsif @post.user_id == current_user.id
      render json: { error: true, error_message: "You can\'t star your own posts." }, status: 403
    else
      StarLog.transaction do
        current_user.update_attributes(stars: current_user.stars - 1)
        @post.user.update_attributes(has_new_stars: true)
        @post.update_attributes(stars: @post.stars + 1)
        star_log = StarLog.find_by(post_id: @post.id, user_id: current_user.id)
        if star_log
          star_log.update_attributes({count: star_log.count + 1, :new => true})
        else
          StarLog.create({user_id: current_user.id, post_id: @post.id, author_id: @post.user_id, :new => true, count: 1})
        end
      end
      
      render json: { success: true, post_stars: @post.stars, user_stars: current_user.stars }
    end
  end

private

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:content, :topic_id)
  end

end
