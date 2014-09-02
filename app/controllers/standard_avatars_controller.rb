class StandardAvatarsController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: :create

  # GET /standard_avatars
  # GET /standard_avatars.json
  def index
  end

  # GET /standard_avatars/1
  # GET /standard_avatars/1.json
  def show
  end

  # GET /standard_avatars/new
  def new
  end

  # GET /standard_avatars/1/edit
  def edit
  end

  # POST /standard_avatars
  # POST /standard_avatars.json
  def create
    @standard_avatar = StandardAvatar.new(standard_avatar_params)

    uploaded_file = params[:standard_avatar][:uploaded_file]
    if uploaded_file.nil?
      flash[:alert] = "Please specify a file to upload." 
      render action: 'new'
      return
    elsif Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48
      flash[:alert] = "Avatar images cannot be larger than 48px x 48px"
      render action: 'new'
      return
    end

    respond_to do |format|
      if @standard_avatar.save
        @standard_avatar.set_image(uploaded_file)
        format.html { redirect_to @standard_avatar, notice: 'Standard avatar was successfully created.' }
        format.json { render action: 'show', status: :created, location: @standard_avatar }
      else
        format.html { render action: 'new' }
        format.json { render json: @standard_avatar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /standard_avatars/1
  # PATCH/PUT /standard_avatars/1.json
  def update

    uploaded_file = params[:standard_avatar][:uploaded_file]
    if uploaded_file && (Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48)
      flash[:alert] = "Avatar images cannot be larger than 48px x 48px"
      render action: 'edit'
      return
    end

    respond_to do |format|
      if @standard_avatar.update(standard_avatar_params)
        @standard_avatar.set_image(uploaded_file)
        format.html { redirect_to @standard_avatar, notice: 'Standard avatar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @standard_avatar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /standard_avatars/1
  # DELETE /standard_avatars/1.json
  def destroy
    @standard_avatar.destroy
    respond_to do |format|
      format.html { redirect_to standard_avatars_url }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def standard_avatar_params
      params.require(:standard_avatar).permit(:name, :image, :rights)
    end
end
