class Services::GivingTreeController < ApplicationController

  def index
    @items = Item.includes(:item_template).where(user_id: current_user.id, location: 0)
    @items = @items.to_a.sort! {|x,y| x.item_template.name <=> y.item_template.name}
  end

end