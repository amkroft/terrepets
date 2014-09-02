class PetsController < ApplicationController

  # before_action :set_pet, only: [:show, :edit, :update, :destroy]
  # after_filter "save_previous_url", only: [:new]

  load_and_authorize_resource
  skip_load_resource only: [:create, :index]

  # def save_previous_url
    # session[:previous_url] is a Rails built-in variable to save last url.
    # session[:my_previouse_url] = URI(request.referer).path
    # @previous_url = session[:previous_url]
  # end

  # GET /pets
  # GET /pets.json
  def index
    # @collection.total_pages
    @pets = Pet.paginate(page: params[:page]).order('name ASC')
  end

  # GET /pets/1
  # GET /pets/1.json
  def show
  end

  # GET /pets/new
  def new
    # @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets
  # POST /pets.json
  def create
    @pet = Pet.new(pet_params)
    @pet.birthday = Time.now
    @pet.user_id = current_user.id

    respond_to do |format|
      if @pet.save
        format.html { redirect_to @pet, notice: "Pet #{@pet.name } was successfully created." }
        format.json { render action: 'show', status: :created, location: @pet }
      else
        format.html { render action: 'new' }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1
  # PATCH/PUT /pets/1.json
  def update
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @pet, notice: "Pet #{@pet.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1
  # DELETE /pets/1.json
  def destroy
    @pet.destroy
    respond_to do |format|
      format.html { redirect_to pets_url }
      format.json { head :no_content }
    end
  end

  # GET /pets/1/equip
  def equip
    equipment_ids = ItemTemplate.where(is_equipment: true).pluck(:id)
    if equipment_ids.any?
      @equipment = Item.includes(:item_template).where("user_id = ? AND location = 0 AND health > 0 AND item_template_id IN (?)", current_user.id, equipment_ids)
      @equipment = @equipment.to_a.sort! {|x,y| x.item_template.name <=> y.item_template.name}
    else
      @equipment = []
    end
  end

  # PUT /pets/1/equip
  def update_equip
    old_equip = Item.find_by(pet_id: params[:id])
    old_equip.update_attributes(pet_id: nil, location: 0) if old_equip

    new_equip = Item.find(params[:item])
    new_equip.update_attributes(pet_id: params[:id], location: 4)

    redirect_to house_path
  end

  # PUT /pets/1/unequip
  def unequip
    equip = @pet.item
    if equip
      equip.update_attributes(location: 0, pet_id: nil)
      redirect_to house_path
    else
      redirect_to equip_pet_path(@pet.id), alert: 'Pet does not have any equipment to unequip.'
    end
  end

  # GET /pets/1/hour_logs
  def hour_logs
    @hour_logs = @pet.hour_logs.paginate(page: params[:page]).order(created_at: :desc, hour: :asc)
  end

  # GET /pets/1/reincarnate
  def reincarnation
  end

  # POST /pets/1/reincarnate
  def reincarnate
    if !params.has_key?(:physical_trait) || !params.has_key?(:mental_trait)
      @error = "You must select one mental trait and one physical trait for #{@pet.name}."
      render :reincarnation
    elsif !params.has_key?(:skills)
      @error = "You must select new skills for #{@pet.name}."
      render :reincarnation
    elsif params[:skills].size != 2
      @error = "You must select exactly two new skills for #{@pet.name}."
      render :reincarnation
    else
      new_birthday = Time.now
      new_reincarnation = PetReincarnation.new(
        pet_id: @pet.id, 
        born_on: @pet.birthday, 
        reincarnated_on: new_birthday, 
        masteries: @pet.masteries_array,
        level: @pet.level,
        graphic: @pet.pet_template.image)

      num_of_masteries = @pet.masteries_array.size
      puts "num_of_masteries: #{num_of_masteries}"
      @pet.reset_masteries
      @pet.reset_skills
      @pet.send("#{params[:physical_trait]}=", 1.0)
      @pet.send("#{params[:mental_trait]}=", 1.0)
      params[:skills].each { |skill| @pet.send("#{skill}=", 1.0) }
      @pet.birthday = new_birthday
      @pet.pet_template_id = params[:pet_template] if params.has_key? :pet_template

      equip = @pet.item
      num_of_masteries = @pet.masteries_array.size
      karma = ((num_of_masteries + 1) * num_of_masteries) / 2
      @current_user.karma += karma

      PetReincarnation.transaction do
        new_reincarnation.save
        equip.update_attributes(location: 0, pet_id: nil) if equip
        @pet.save
        @current_user.save
      end

      redirect_to house_path, {notice: "#{@pet.name} has been reincarnated!  You've gained #{karma} Karma."}
    end
  end
  

private

  # Never trust parameters from the scary internet, only allow the white list through.
  def pet_params
    if can? :manage, @pet
      params.require(:pet).permit(:name, :birthday, :gender, :user_id, :pet_template_id, :pet_template_type, :profile)
    else
      params.require(:pet).permit(:name, :profile)
    end
  end
end
