class MakeablesController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: :create

  # GET /makeables
  # GET /makeables.json
  def index
    @makeables = @makeables.to_a.sort! do |x,y|
      if x.difficulty == y.difficulty && x.item_template && y.item_template
        x.item_template.name <=> y.item_template.name
      else
        x.difficulty <=> y.difficulty
      end
    end
  end

  # GET /makeables/1
  # GET /makeables/1.json
  def show
  end

  # GET /makeables/new
  def new
  end

  # GET /makeables/1/edit
  def edit
  end

  # POST /makeables
  # POST /makeables.json
  def create
    @makeable = Makeable.new(makeable_params)

    respond_to do |format|
      if @makeable.save
        format.html { redirect_to @makeable, notice: 'Makeable was successfully created.' }
        format.json { render action: 'show', status: :created, location: @makeable }
      else
        format.html { render action: 'new' }
        format.json { render json: @makeable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /makeables/1
  # PATCH/PUT /makeables/1.json
  def update
    respond_to do |format|
      if @makeable.update(makeable_params)
        format.html { redirect_to @makeable, notice: 'Makeable was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @makeable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /makeables/1
  # DELETE /makeables/1.json
  def destroy
    @makeable.destroy
    respond_to do |format|
      format.html { redirect_to makeables_url }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def makeable_params
      params.require(:makeable).permit(:difficulty, :item_template_id, :ingredients, :quantity)
    end
end
