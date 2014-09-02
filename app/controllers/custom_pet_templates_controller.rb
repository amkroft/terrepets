class CustomPetTemplatesController < ApplicationController
  # before_action :set_custom_pet_template, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource
  skip_load_resource only: :create

  # GET /custom_pet_templates
  # GET /custom_pet_templates.json
  def index
    # @custom_pet_templates = CustomPetTemplate.all
  end

  # GET /custom_pet_templates/1
  # GET /custom_pet_templates/1.json
  def show
  end

  # GET /custom_pet_templates/new
  def new
    # @custom_pet_template = CustomPetTemplate.new
    # @post, :user_id => current_user.id
  end

  # GET /custom_pet_templates/1/edit
  def edit
  end

  # POST /custom_pet_templates
  # POST /custom_pet_templates.json
  def create
    @custom_pet_template = CustomPetTemplate.new(custom_pet_template_params)

    uploaded_file = params[:custom_pet_template][:uploaded_file]
    if uploaded_file.nil?
      flash[:alert] = "Please specify a file to upload." 
      render action: 'new'
      return
    elsif Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48
      flash[:alert] = "Pet images cannot be larger than 48px x 48px"
      render action: 'new'
      return
    end

    @custom_pet_template.uploader ||= current_user.id

    respond_to do |format|
      if @custom_pet_template.save
        @custom_pet_template.set_image(uploaded_file)
        format.html { redirect_to @custom_pet_template, notice: 'Custom pet template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @custom_pet_template, :uploader => current_user.id }
      else
        format.html { render action: 'new' }
        format.json { render json: @custom_pet_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /custom_pet_templates/1
  # PATCH/PUT /custom_pet_templates/1.json
  def update

    uploaded_file = params[:custom_pet_template][:uploaded_file]
    if uploaded_file && (Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48)
      flash[:alert] = "Pet images cannot be larger than 48px x 48px"
      render action: 'edit'
      return
    end

    respond_to do |format|
      if @custom_pet_template.update(custom_pet_template_params)
        @custom_pet_template.set_image(uploaded_file)
        format.html { redirect_to @custom_pet_template, notice: 'Custom pet template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @custom_pet_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_pet_templates/1
  # DELETE /custom_pet_templates/1.json
  def destroy
    @custom_pet_template.destroy
    respond_to do |format|
      format.html { redirect_to custom_pet_templates_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_pet_template
      @custom_pet_template = CustomPetTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def custom_pet_template_params
      params.require(:custom_pet_template).permit(:name, :image, :uploader, :recipient, :author, :rights)
    end
end
