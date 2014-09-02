class Commerce::FleaMarketController < ApplicationController

  def index
    items = Item.where('location = 1 AND price > 0')
    users = items.map { |item| item.user_id }
    users.uniq!
    @users = User.where(id: users).order(:display_name)
  end

  def search
    templates = ItemTemplate.where('name LIKE ?', "%#{params[:query]}%").to_a

    @stores = {}
    items = Item.includes(:user, :item_template).where('location = 1 AND price > 0 AND item_template_id IN (?)', templates)
    items.each do |item|
      if @stores.has_key? item.item_template.name
        if @stores[item.item_template.name].has_key? item.user_id
          @stores[item.item_template.name][item.user_id][:lowest_price] = item.price if @stores[item.item_template.name][item.user_id][:lowest_price] > item.price
        else
          @stores[item.item_template.name][item.user_id] = {user: item.user, lowest_price: item.price}
        end
      else
        @stores[item.item_template.name] = {item.user_id => {user: item.user, lowest_price: item.price}}
      end
    end

    render :results
  end

end