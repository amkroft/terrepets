class ItemsController < ItemActionController

  # before_action :set_item, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource :except => :action
  skip_load_resource only: [:create, :index]
  # skip_load_resource :only => :sell

  # GET /items
  # GET /items.json
  def index
    @items = Item.paginate(page: params[:page]).order('item_template_id ASC')
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  # POST /items/action
  def action
    message = super

    if request.env["HTTP_REFERER"].nil?
      $stderr.puts 'Eyes see a sneaky...'
      redirect_to house_path, message
    else
      redirect_to :back, message
    end
  end

private

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:item_template_id, :user_id, :location, :price, :origin_note, :user_note)
  end

end
