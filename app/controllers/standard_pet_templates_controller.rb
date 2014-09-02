class StandardPetTemplatesController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: :create

  # GET /standard_pet_templates
  # GET /standard_pet_templates.json
  def index
  end

  # GET /standard_pet_templates/1
  # GET /standard_pet_templates/1.json
  def show
  end

  # GET /standard_pet_templates/new
  def new
  end

  # GET /standard_pet_templates/1/edit
  def edit
  end

  # POST /standard_pet_templates
  # POST /standard_pet_templates.json
  def create
    @standard_pet_template = StandardPetTemplate.new(standard_pet_template_params)

    uploaded_file = params[:standard_pet_template][:uploaded_file]
    if uploaded_file.nil?
      flash[:alert] = "Please specify a file to upload." 
      render action: 'new'
      return
    elsif Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48
      flash[:alert] = "Pet images cannot be larger than 48px x 48px"
      render action: 'new'
      return
    end

    respond_to do |format|
      if @standard_pet_template.save
        @standard_pet_template.set_image(uploaded_file)
        format.html { redirect_to @standard_pet_template, notice: 'Standard pet template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @standard_pet_template }
      else
        format.html { render action: 'new' }
        format.json { render json: @standard_pet_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /standard_pet_templates/1
  # PATCH/PUT /standard_pet_templates/1.json
  def update

    uploaded_file = params[:standard_pet_template][:uploaded_file]
    if uploaded_file && (Dimensions.width(uploaded_file.tempfile) > 48 || Dimensions.width(uploaded_file.tempfile) > 48)
      flash[:alert] = "Pet images cannot be larger than 48px x 48px"
      render action: 'edit'
      return
    end

    respond_to do |format|
      if @standard_pet_template.update(standard_pet_template_params)
        @standard_pet_template.set_image(uploaded_file)
        format.html { redirect_to @standard_pet_template, notice: 'Standard pet template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @standard_pet_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /standard_pet_templates/1
  # DELETE /standard_pet_templates/1.json
  def destroy
    @standard_pet_template.destroy
    respond_to do |format|
      format.html { redirect_to standard_pet_templates_url }
      format.json { head :no_content }
    end
  end

private

  # Never trust parameters from the scary internet, only allow the white list through.
  def standard_pet_template_params
    params.require(:standard_pet_template).permit(:name, :image, :rights)
  end
end
