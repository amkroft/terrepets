class TopicsController < ApplicationController

  before_action :load_topic, only: :create
  load_and_authorize_resource :except => :index

  # GET /topics
  # GET /topics.json
  def index
    redirect_to forum_path(params[:forum_id])
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @forum = Forum.find(@topic.forum_id)
    @posts = Post.includes(:user).where(topic_id: @topic.id).paginate(page: params[:page]).order('created_at ASC')
    respond_to do |format|
      format.html { }
      format.json { render json: @topic }
    end
  end

  # GET /topics/new
  def new
    @forum = Forum.find(params[:forum_id])
    raise CanCan::AccessDenied if @forum.name.eql?('City Hall') && !current_user.is_admin
	  @post = Post.new
    @topic.forum_id = @forum.id
  end

  # GET /topics/1/edit
  def edit
    @forum = Forum.find(params[:forum_id])
    @post = @topic.first_post
  end

  # POST /topics
  # POST /topics.json
  def create  
    # Need to pull information on topic and post and save respectively
    @topic.assign_attributes(:last_poster_id => current_user.id, :last_post_at => Time.now, :user_id => current_user.id)
    if Forum.city_hall_forum_id == @topic.forum_id
      User.update_all(city_hall_notice: true)
    end

    if(@topic.save)	
  	  @post = Post.new(post_params)
  	  @post.assign_attributes(:topic_id => @topic.id, :user_id => current_user.id)
      if(@post.save)
        @topic.update_attributes(:first_post_id => @post.id)
    		redirect_to forum_topic_path(@topic.forum_id, @topic)
    	else
        redirect_to :action => 'new'
      end
    else
      redirect_to :action => 'new'
    end
	
  end  

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    @post = Post.find(params[:post][:id])
    respond_to do |format|
      if @topic.update(topic_params) && @post.update(post_params)
        format.html { redirect_to forum_topic_path(@topic.forum_id, @topic), notice: 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy    
    @topic.destroy 
    respond_to do |format|
      format.html { redirect_to forum_path(params[:forum_id])  }
      format.json { head :no_content }
    end
  end

private

    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def load_topic
      @topic = Topic.new(topic_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:forum_id, :name, :icon, :stickied)
    end
	
    def post_params
      params.require(:post).permit(:content)
    end

end
