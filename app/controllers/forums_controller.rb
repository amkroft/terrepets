class ForumsController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: :create
  skip_authorize_resource only: [:stars_received, :stars_given]

  # GET /forums
  # GET /forums.json
  def index
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
    @stickied_topics = Topic.where(forum_id: @forum.id, stickied: true).order('last_post_at DESC')
    @topics = Topic.where(forum_id: @forum.id, stickied: false).order('last_post_at DESC')
    if @forum.id == Forum.city_hall_forum_id
      current_user.update_attributes(city_hall_notice: false) if current_user.city_hall_notice
    end
  end

  # GET /forums/new
  def new
  end

  # GET /forums/1/edit
  def edit
  end

  # POST /forums
  # POST /forums.json
  def create
    @forum = Forum.new(forum_params)

    respond_to do |format|
      if @forum.save
        format.html { redirect_to @forum, notice: 'Forum was successfully created.' }
        format.json { render action: 'show', status: :created, location: @forum }
      else
        format.html { render action: 'new' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forums/1
  # PATCH/PUT /forums/1.json
  def update
    respond_to do |format|
      if @forum.update(forum_params)
        format.html { redirect_to forums_path, notice: 'Forum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.json
  def destroy
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to forums_url }
      format.json { head :no_content }
    end
  end

  # GET /forums/stars_received
  def stars_received
    @posts = Post.includes(:topic).where("user_id = ? AND stars > 0", current_user.id).paginate(page: params[:page]).order('stars DESC')
    @star_count = Post.where(user_id: current_user.id).sum(:stars)

    if current_user.has_new_stars
      star_logs = StarLog.where(author_id: current_user.id, :new => true)
      newly_starred_post_ids = star_logs.map(&:post_id)
      newly_starred_post_ids.uniq!
      @newly_starred_posts = Post.includes(:topic).find(newly_starred_post_ids)
      
      StarLog.transaction do
        current_user.update_attributes(has_new_stars: false)
        StarLog.where(author_id: current_user.id, :new => true).update_all(:new => false)
      end
    end
  end

  # GET /forums/stars_given
  def stars_given
    @total_stars_given = StarLog.where(user_id: current_user.id).sum(:count)
    @star_logs = StarLog.includes(post: [:topic, :user]).where(user_id: current_user.id).paginate(page: params[:page]).order('count DESC')
    # @starred_posts = Post.includes(:topic).find(star_logs.map(&:post_id)).paginate(page: params[:page]).order('stars DESC')
  end

  def irc
  end

private

  # Never trust parameters from the scary internet, only allow the white list through.
  def forum_params
    params.require(:forum).permit(:name, :description)
  end

end
