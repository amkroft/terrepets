class Services::RecyclingController < ApplicationController

  def index
    @recyclable_items = ItemTemplate.where("recycle_ingredients IS NOT NULL AND recycle_ingredients <> ''").pluck(:id)
    @items = Item.includes(:item_template).where(user_id: current_user.id, location: 0, item_template_id: @recyclable_items)
    @items = @items.to_a.sort! {|x,y| x.item_template.name <=> y.item_template.name}
  end

end