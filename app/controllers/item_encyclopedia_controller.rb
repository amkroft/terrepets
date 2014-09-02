class ItemEncyclopediaController < ApplicationController

  def show
    case params[:name]
    when '4-leaf_clover'
      name = '4-leaf Clover'
    when '3-leaf_clover'
      name = '3-leaf Clover'
    else
      name = params[:name].titleize
    end
    @item_template = ItemTemplate.find_by(name: name)
    if @item_template && @item_template.name[0..1] != 'xx'
      render "item_templates/show"
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end