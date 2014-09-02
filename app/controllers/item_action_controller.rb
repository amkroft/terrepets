class ItemActionController < ApplicationController

  def action
    @location = get_location

    if !params.has_key?(:items) && !params.has_key?(:item_names)
      message = { alert: 'No items selected, so no actions taken.' }
    else

      @user_stats = UserStatistic.find_by(user_id: current_user.id) || UserStatistic.new(user_id: current_user.id)

      if ['Move','Give Gifts'].include? params[:commit]
        if params[:item_names]
          item_templates = ItemTemplate.where(name: params[:item_names]).pluck(:id)
          @items = Item.where(user_id: current_user.id, location: @location, item_template_id: item_templates).pluck(:id)
        else
          @items = params[:items]
        end
      else
        if params[:item_names]
          item_templates = ItemTemplate.where(name: params[:item_names]).pluck(:id)
          @items = Item.includes(:item_template).where(user_id: current_user.id, location: @location, item_template_id: item_templates)
        else
          @items = Item.includes(:item_template).where(id: params[:items])
        end
      end

      case params[:commit]
      when 'Feed to'
        message = feed
      when 'Gamesell'
        message = gamesell
      when 'Move'
        message = move
      when 'Recycle'
        message = recycle
      when 'Give Gifts'
        message = give
      when 'Prepare'
        message = prepare
      else
        $stderr.puts "User #{current_user.display_name} triggered unknown item action: #{parmas[:commit]}"
        message = { alert: "Unknown action: #{params[:commit]}" }
      end
      message
    end

  end

private

  def get_location
    location = request.referrer ? request.referrer.split('?')[0].split('/')[3] : 'none'
    case(location)
    when 'stores'
      1
    when 'house'
      0
    when 'incoming'
      2
    else
      $stderr.puts "ItemActionController.get_location could not parse location #{location}"
      -1
    end
  end

  def gamesell
    earned = 0
    money_earned = 0
    @items.each do |item|
      template = item.item_template
      money_earned += template.value
      earned += template.value
    end
    Item.transaction do
      Item.delete(@items.map(&:id))
      current_user.update_attributes(money: current_user.money + money_earned)
      @user_stats.update_attributes(items_gamesold: @user_stats.items_gamesold + @items.size, money_from_gameselling: @user_stats.money_from_gameselling + money_earned)
    end
    { notice: "#{@items.size} items gamesold for #{earned} monies." }
  end

  def feed
    @pet = Pet.find(params[:pet_id])

    if @pet.sleeping 
      { alert: "#{@pet.name} is asleep" }
    elsif @pet.food >= @pet.max_food
      { alert: "#{@pet.name} is full" }
    else
      messages = {alert: "", notice: ""}
      eaten = []
      not_edible = []
      not_eaten = []
      @items.each do |item|
        if @pet.food >= @pet.max_food
          not_eaten << item
        elsif item.item_template.edible

          # REDACTED IF STATEMENT
          # SUBSTITUTED:
          @pet.food += item.item_template.edible_size

          eaten << item
        else
          not_edible << item
        end
      end

      if eaten.size <= 5
        eaten.each do |item|
          messages[:notice] += "#{@pet.name} ate #{item.item_template.name}.<br>"
        end
        items = eaten.map do |item|
          item.item_template.name
        end
        hour_log = "Was fed: #{items.join(', ')}."
      else
        messages[:notice] = "#{@pet.name} ate #{pluralize(eaten.size, 'food')}.<br>"
        hour_log = "Was fed #{pluralize(eaten.size, 'food')}."
      end

      if eaten.size > 0
        Pet.transaction do
          @pet.save
          Item.delete_all(id: eaten)
          HourLog.create(pet_id: @pet.id, description: hour_log, hour: 0, real_time: true)
          @user_stats.update_attributes(hand_fet_pets: @user_stats.hand_fet_pets + 1)
        end
      end

      if not_edible.size <= 5
        not_edible.each do |item|
          messages[:alert] += "#{item.item_template.name} is not edible.<br>"
        end
      else
        messages[:alert] += "#{pluralize(not_edible.size, 'food')} not eaten.  #{not_edible.size == 1 ? 'It is' : 'They are'} not edible.<br>"
      end

      if not_eaten.size <= 5
        not_eaten.each do |item|
          messages[:alert] += "#{item.item_template.name} could not be eaten.  #{@pet.name} is full.<br>"
        end
      else
        messages[:alert] += "#{pluralize(not_eaten.size, 'food')} not eaten.  #{@pet.name} is full.<br>"
      end

      messages[:notice].chomp('<br>')
      messages[:alert].chomp('<br>')
      messages
    end
  end

  def move
    locations = ['My House','My Store']
    Item.where(id: @items).update_all(location: params[:location], price: nil) # THIS
    {notice: "#{pluralize(@items.size, 'item')} moved to #{locations[params[:location].to_i]}."}
  end

  def recycle
    messages = {alert: "", notice: ""}
    recovered_items = []
    not_recycled_items = 0
    to_destroy_items = []
    to_create_items = []

    @items.each do |item|
      if item.item_template.recyclable?
        ingredients = item.item_template.recycle_ingredients.split(',')
        ingredients.each do |data|
          data = data.split('|')
          item_template = ItemTemplate.find(data[0])
          data[1].to_i.times do
            # REDACTED IF STATEMENT
            # SUBSTITUTED:
            if true
              to_create_items << {location: 2, user_id: current_user.id, item_template: item_template, origin_note: 'Recovered from recycling.'}
              recovered_items << item_template.name
            end
          end
        end
        to_destroy_items << item.id

      else
        messages[:alert] += "#{item.item_template.name} cannot be recycled.<br>"
        not_recycled_items += 1
      end
    end

    # TODO: Turn Item.create into one sql query of inserts
    Item.transaction do
      Item.delete(to_destroy_items)
      Item.create(to_create_items)
      @user_stats.update_attributes(items_recycled: @user_stats.items_recycled + to_destroy_items.size, items_received_from_recycling: @user_stats.items_received_from_recycling + to_create_items.size)
    end

    if not_recycled_items > 10
      messages[:alert] = "#{pluralize(not_recycled_items,'item')} could not be recycled as they are not recyclable."
    end

    if(recovered_items.any?)
      recovered_items.sort!
      items_string = recovered_items.join(', ')
      if recovered_items.size > 10
        messages[:notice] += "#{pluralize(recovered_items.size, 'item')} recovered from recycling."
      else
        messages[:notice] += "#{pluralize(recovered_items.size, 'item')} recovered from recycling: #{items_string}."
      end
    else
      messages[:notice] += 'No items recovered from recycling.'
    end

    messages
  end


  def give
    # REDACTED USER.WHERE STATEMENT
    # SUBSTITUTED:
    users = User.all

    if users.size == 0 
      { alert: 'There are no recently active users to gift items too :(' }
    else
      item_updates = {}
      @items.each do |item_id|
        user_id = users.sample
        if item_updates[user_id]
          item_updates[user_id] << item_id
        else
          item_updates[user_id] = [item_id]
        end
      end

      Item.transaction do
        item_updates.each do |user_id, item_ids|
          Item.where(id: item_ids).update_all({location: 2, user_id: user_id, user_note: "This item was given to you#{params[:add_name] ? ' by ' + current_user.display_name : ''} via the Giving Tree."})
        end
        # current_user.update_attributes(gifted_item_total: current_user.gifted_item_total + @items.size)
        @user_stats.update_attributes(gifted_items: @user_stats.gifted_items + @items.size)
      end

      notice = "Put #{pluralize(@items.size, 'item')} under the Giving Tree.<br>"
      notice += check_giving_tree_badges(users.size)
      notice.chomp!('<br>')

      { notice: notice }
    end
  end

  def check_giving_tree_badges(active_users)
    message = ""
    # REDACTED
    message
  end


  def prepare
    ingredients = Hash.new(0)
    @items.each do |item|
      ingredients[item.item_template.id] += 1
    end

    gcd = 0
    ingredients.values.each { |quantity| gcd = quantity.gcd(gcd) }

    recipe = recipe(ingredients, 1)

    if recipe
      quantity_prepared = 1
    elsif gcd > 1
      recipe = recipe(ingredients, gcd)
      if recipe
        quantity_prepared = gcd
      elsif gcd % 2 == 0
        recipe = recipe(ingredients, gcd/2)
        quantity_prepared = gcd/2 if recipe
      end
    end

    if recipe.nil?
      { alert: 'Nothing can be prepared from those ingredients.' }
    else
      to_create = []
      items_to_create = recipe.results.split(',')
      items_to_create.each do |item|
        (item_template_id, quantity) = item.split('|')
        (quantity.to_i * quantity_prepared).times do
          to_create << {user_id: current_user.id, location: @location, origin_note: "Prepared by #{current_user.display_name}.", item_template_id: item_template_id}
        end
      end

      Item.transaction do
        Item.create(to_create)
        Item.delete(@items.map(&:id))
        # @user_stats.update_attributes(recipes_made: @user_stats.recipes_made + @items.size)
      end

      prepared_items = items_to_create.map do |item|
        (item_template_id, quantity) = item.split('|')
        "#{quantity.to_i * quantity_prepared}x #{ItemTemplate.where(id: item_template_id).pluck(:name)[0]}"
      end
      { notice: "You prepared " + comma_list(prepared_items)}
    end
  end

  def recipe(ingredient_hash, divisor)
    search_ingredients = []
    ingredient_hash.keys.sort.each do |item_template_id|
      search_ingredients << "#{item_template_id}|#{ingredient_hash[item_template_id]/divisor}"
    end
    search_ingredients = search_ingredients.join(',')

    Recipe.includes(:item_template).find_by(ingredients: search_ingredients)
  end

  def comma_list(item_list)
    holder = ''
    item_list.each_with_index do |item, index|
      holder += item
      if index == item_list.size - 2 && item_list.size == 2
        holder += ' and '
      elsif index == item_list.size - 2
        holder += ', and '
      elsif index < item_list.size - 1
        holder += ', '
      end
    end
    holder
  end

end
