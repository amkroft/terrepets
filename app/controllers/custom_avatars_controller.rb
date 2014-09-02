class CustomAvatarsController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: :create

  # GET /custom_avatars
  # GET /custom_avatars.json
  def index
  end

  # GET /custom_avatars/1
  # GET /custom_avatars/1.json
  def show
  end

  # GET /custom_avatars/new
  def new
  end

  # GET /custom_avatars/1/edit
  def edit
  end

  # POST /custom_avatars
  # POST /custom_avatars.json
  def create
    @custom_avatar = CustomAvatar.new(custom_avatar_params)

    uploaded_file = params[:custom_avatar][:uploaded_file]
    if uploaded_file.nil?
      flash[:alert] = "Please specify a file to upload." 
      render action: 'new'
      return
    elsif Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48
      flash[:alert] = "Avatar images cannot be larger than 48px x 48px"
      render action: 'new'
      return
    end

    @custom_avatar.uploader ||= current_user.id

    respond_to do |format|
      if @custom_avatar.save
        @custom_avatar.set_image(uploaded_file)
        format.html { redirect_to @custom_avatar, notice: 'Custom avatar was successfully created.' }
        format.json { render action: 'show', status: :created, location: @custom_avatar}
      else
        format.html { render action: 'new' }
        format.json { render json: @custom_avatar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_avatars/1
  # PATCH/PUT /custom_avatars/1.json
  def update

    uploaded_file = params[:custom_avatar][:uploaded_file]
    if uploaded_file && (Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48)
      flash[:alert] = "Avatar images cannot be larger than 48px x 48px"
      render action: 'edit'
      return
    end

    respond_to do |format|
      if @custom_avatar.update(custom_avatar_params)
        @custom_avatar.set_image(uploaded_file)
        format.html { redirect_to @custom_avatar, notice: 'Custom avatar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @custom_avatar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_avatars/1
  # DELETE /custom_avatars/1.json
  def destroy
    @custom_avatar.destroy
    respond_to do |format|
      format.html { redirect_to custom_avatars_url }
      format.json { head :no_content }
    end
  end

private

  # Never trust parameters from the scary internet, only allow the white list through.
  def custom_avatar_params
    params.require(:custom_avatar).permit(:name, :image, :uploader, :author, :rights)
  end
  
end
