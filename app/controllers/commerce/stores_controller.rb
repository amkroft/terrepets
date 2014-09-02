class Commerce::StoresController < ItemActionController

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @items = Item.includes(:item_template).where('user_id = ? AND location = 1 AND price > 0', @user.id)
      if params[:condensed] == 'true'
        @items = items_hash
      else
        @items = @items.to_a.sort! {|x,y| x.item_template.name <=> y.item_template.name}
      end
    else
      @user = current_user
      @items = Item.includes(:item_template).where(user_id: @user.id, location: 1)
      if params[:condensed] == 'true'
        @items = items_hash
      else
        @items = @items.to_a.sort! do |x,y|
          if x.item_template.id != y.item_template.id
            x.item_template.name <=> y.item_template.name
          else
            x.id <=> y.id
          end
        end
      end

      @selling_items_total_count = Item.where('user_id = ? AND location = 1 AND price > 0', @user.id).size
      @selling_items_total_cost = Item.where('user_id = ? AND location = 1 AND price > 0', @user.id).sum(:price)
    end
  end

  # TODO Check out updating multiple records at once
  # def sell
  #   if params[:commit] == 'Move'
  #     move_items
  #   elsif params[:commit] == 'Update'
  #     update_item_prices
  #   else
  #     $stderr.puts "User #{current_user.display_name} triggered unknown store action: #{params[:commit]}"
  #     message = { alert: "Unknown action #{params[:commit]}" }
  #   end
  #   redirect_to stores_path, message
  # end 

  def action
    if params[:commit] == 'Update'
      message = update_item_prices
    else
      message = super
    end

    if request.env["HTTP_REFERER"].nil?
      $stderr.puts 'Eyes see a sneaky...'
      redirect_to stores_path, message
    else
      redirect_to :back, message
    end
  end

  def buy
    message = {alert: "", notice: ""}
    if params[:items]

      items = Item.find(params[:items])
      items = items.to_a.reject { |item| item.location != 1 || item.price.nil? || item.price < 1 }

      bad_items_total = params[:items].size - items.size

      total_cost = items.map(&:price).inject(:+)

      if total_cost > current_user.money
        message[:alert] += 'You do not have enough money for the selected items.'
      else
        selling_user = User.find(params[:user_id])

        ActiveRecord::Base.transaction do
          current_user.update_attributes(money: current_user.money - total_cost)
          selling_user.update_attributes(money: selling_user.money + total_cost, has_new_sales: true)
          Item.where(id: items.map(&:id)).update_all(location: 2, user_id: current_user.id, price: nil, user_note: "Bought from #{selling_user.display_name}'s store.")
          StoreTransaction.create({user_id: selling_user.id, description: "#{pluralize(items.size,'item')} sold to #{current_user.display_name}.", amount: total_cost})
        end

        if bad_items_total > 1
          message[:alert] += "#{bad_items_total} items were no longer for sale."
        elsif bad_items_total == 1
          message[:alert] += "#{bad_items_total} item was no longer for sale."
        end

        message[:notice] += "#{items.size} items bought."
      end

    end
    redirect_to stores_path(params[:user_id]), message
  end

private 

  def item_params(values)
    values.permit(:item_template_id, :user_id, :location, :price_items)
  end

  def update_item_prices
    # TODO: Can I mass-update items?
    if params[:item_names]
      item_templates = ItemTemplate.where(name: params[:item_names]).pluck(:id)
      @items = Item.where(user_id: current_user.id, location: 1, item_template_id: item_templates).pluck(:id)
    else
      @items = params[:items]
    end

    items = Item.find(params[:price_items].keys)

    items.each do |item|
      new_price = params[:price_items][item.id.to_s]['price'].to_i
      item.update_attributes(price: new_price) if item.price.to_i != new_price
    end

    {notice: "Store inventory updated."}
  end

  def items_hash
    # @items = Item.includes(:item_template).where(user_id: @user.id, location: 1)
    items_hash = {}

    @items.each do |item|
      price = item.price || 0
      if items_hash.has_key? item.item_template.name
        items_hash[item.item_template.name][:quantity] += 1
        items_hash[item.item_template.name][:highest_price] = item.price if items_hash[item.item_template.name][:highest_price] < price
      else
        items_hash[item.item_template.name] = {value: item.item_template.value, quantity: 1, highest_price: price }
      end
    end

    items_hash.sort_by { |name, data| name }
  end

end