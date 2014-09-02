class ItemTemplatesController < ApplicationController
  # before_action :set_item_template, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource
  skip_load_resource only: [:index, :create]

  # GET /item_templates
  # GET /item_templates.json
  def index
    @item_templates = ItemTemplate.all.paginate(page: params[:page]).order('name ASC')
  end

  # GET /item_templates/1
  # GET /item_templates/1.json
  def show
  end

  # GET /item_templates/new
  def new
    # @item_template = ItemTemplate.new
  end

  # GET /item_templates/1/edit
  def edit
  end

  # POST /item_templates
  # POST /item_templates.json
  def create
    @item_template = ItemTemplate.new(item_template_params)

    respond_to do |format|
      if @item_template.save
        format.html { redirect_to @item_template, notice: 'Item Template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item_template }
      else
        format.html { render action: 'new' }
        format.json { render json: @item_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_templates/1
  # PATCH/PUT /item_templates/1.json
  def update
    respond_to do |format|
      if @item_template.update(item_template_params)
        format.html { redirect_to @item_template, notice: 'Item Template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_templates/1
  # DELETE /item_templates/1.json
  def destroy
    @item_template.destroy
    respond_to do |format|
      format.html { redirect_to item_templates_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_item_template
    @item_template = ItemTemplate.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_template_params
    params.require(:item_template).permit(:name, :description, :category, :edible, :edible_size, :value, :is_equipment, :durability, :equip_crafting, :equip_gathering, :equip_mining, :equip_hunting, :equip_smithing, :equip_intelligence, :equip_dexterity, :equip_strength, :equip_perception, :equip_stamina, :equip_athletics, :equip_thieving, :equip_fishing, :equip_lumberjacking, :equip_stealth, :equip_wits, :recycle_ingredients)
  end
end
