class Commerce::ItemTradesController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: [:index, :create]

	def index
    current_user.update_attributes(trade_notice: false) if current_user.trade_notice
		@item_trades = ItemTrade.where("(user_1_id = ? OR user_2_id = ?) AND status = 0", current_user.id, current_user.id)
	end

  def new
    set_items
  end

  def create
    trade_with = User.find_by(display_name: params[:trade_with])
    @item_trade = ItemTrade.new(item_trade_params)
    @item_trade.sender = current_user
    @item_trade.recipient = trade_with
    if !trade_with
      flash[:alert] = "No user by the name of \"#{params[:trade_with]}\""
      set_items
      render action: 'new'
    elsif trade_with.id == current_user.id
      flash[:alert] = "You can't trade with yourself"
      @item_trade.recipient = nil
      set_items
      render action: 'new'
    elsif @item_trade.money_sending(current_user) < 0
      flash[:alert] = "Negative amounts of money are not allowed"
      set_items
      render action: 'new'
    elsif @item_trade.money_sending(current_user) > current_user.money
      flash[:alert] = "You do not have that much money to give"
      set_items
      render action: 'new'
    else
      items = Item.where(id: params[:items], user_id: current_user.id, location: 0)
      
      @item_trade.set_items(items.map(&:id), current_user)
      @item_trade.set_description(current_user, create_description(@item_trade.money_sending(current_user), @item_trade.items_sending(current_user)))

      current_user.money -= @item_trade.money_receiving(trade_with)

      trade_with.trade_notice = true

      ItemTrade.transaction do
        @item_trade.save
        current_user.save
        trade_with.save
        items.update_all(location: 4)
      end

      redirect_to trading_post_path, {notice: 'Trade successfully started.'}
      # else
      #   render action: 'new'
      # end  
    end
  end

  def accept
    other_user = User.find(@item_trade.other_user(current_user.id))
    current_user.money = current_user.money + @item_trade.money_receiving(current_user)
    other_user.money = other_user.money + @item_trade.money_receiving(other_user)
    other_user.trade_notice = true
    ItemTrade.transaction do
      @item_trade.update_attributes(status: 2)
      current_user.save
      other_user.save
      Item.where(id: @item_trade.items_receiving(current_user)).update_all(
        location: 2, 
        user_id: current_user.id, 
        user_note: "You traded with #{@item_trade.anonymous_for(current_user) ? 'someone mysterious' : other_user.display_name} for this item."
      )
      Item.where(id: @item_trade.items_receiving(other_user)).update_all(
        location: 2, 
        user_id: other_user.id, 
        user_note: "You traded with #{@item_trade.anonymous_for(other_user) ? 'someone mysterious' : current_user.display_name} for this item."
      )
    end
    redirect_to trading_post_path, {notice: "Trade has been accepted. Any items will be located in your <a href='#{incoming_path}'>Incoming</a>"}
  end

  def negotiate
    set_items
  end

  def cancel
    @item_trade.status = 1

    current_user.money += @item_trade.money_sending(current_user)

    other_user = User.find(@item_trade.other_user(current_user.id))
    other_user.money += @item_trade.money_sending(other_user)
    other_user.trade_notice = true

    ItemTrade.transaction do
      @item_trade.save
      current_user.save
      other_user.save
      Item.where(id: @item_trade.items_sending(current_user)).update_all(location: 2)
      Item.where(id: @item_trade.items_sending(other_user)).update_all(location: 2)
    end

    redirect_to trading_post_path, { notice: "Trade has been canceled. Any items have been returned to your Incoming." }
  end

  def process_negotiation
    @item_trade.attributes = item_trade_params
    if @item_trade.money_sending(current_user) < 0
      flash[:alert] = "Negative amounts of money are not allowed"
      set_items
      render action: 'negotiate'
    elsif @item_trade.money_sending(current_user) > current_user.money
      flash[:alert] = "You do not have that much money to give"
      set_items
      render action: 'negotiate'
    else
      items = Item.where(id: params[:items], user_id: current_user.id, location: 0)

      
      @item_trade.negotiated = true
      @item_trade.set_items(items.map(&:id), current_user)
      @item_trade.set_description(current_user, create_description(@item_trade.money_sending(current_user), @item_trade.items_sending(current_user)))

      other_user = User.find(@item_trade.other_user(current_user.id))
      other_user.trade_notice = true

      current_user.money -= @item_trade.money_sending(current_user)

      ItemTrade.transaction do
        @item_trade.save
        other_user.save
        current_user.save
        items.update_all(location: 4)
      end

      redirect_to trading_post_path, {notice: 'Trade has been negotiated.'}
    end
  end

private

  def item_trade_params
    params.require(:item_trade).permit(:anonymous, :gift, :item_1_ids, :item_2_ids, :money_1, :money_2, :message)
  end

  def set_items
    @items = Item.includes(:item_template).where(user_id: current_user.id, location: 0)
    @items = @items.to_a.sort! do |x,y|
      x.item_template.name <=> y.item_template.name
    end
  end

  def create_description(monies, items)
    description = ""

    description += monies.to_s + " monies<br>" if monies > 0
    
    if items
      items = Item.includes(:item_template).find(items)


      items_hash = {}
      items.each do |item|
        if items_hash.has_key? item.item_template.name
          items_hash[item.item_template.name][:quantity] += 1
          items_hash[item.item_template.name][:ids] << item.id
        else
          items_hash[item.item_template.name] = {ids: [item.id], quantity: 1}
        end
      end

      items_hash.keys.sort.each do |item_name|
        link = "<a href='#{item_encyclopedia_path(item_name.gsub(/ /, '_').downcase)}' target='_blank'>#{item_name}</a>"
        description += "#{items_hash[item_name][:quantity]}x #{link}<br>"
      end  
    end

    description.chomp('<br>')
    if description.empty?
      nil
    else
      description
    end
  end

end