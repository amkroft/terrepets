class Services::PatternShopController < ApplicationController
  def index
    @acceptable_items = Item.includes(:item_template).where(user_id: current_user.id, item_template_id: acceptable_item_ids, location: 0).order('item_template_id ASC')
  end

  def trade
    if params[:items]
      items = Item.where(id: params[:items], location: 0, user_id: current_user.id)
      if items.empty?
        redirect_to pattern_shop_path, alert: 'No valid items selected.'
        return
      end
      items_to_trade = []
      items.each do |item|
        if acceptable_item_ids.include? item.item_template_id
          items_to_trade << item
        end
      end

      maze_pieces = []
      Item.transaction do
        items_to_trade.size.times do 
          maze_pieces << Item.create(user_id: current_user.id, location: 2, item_template_id: maze_piece_ids.sample, origin_note: 'Traded for at the Pattern Shop')
        end
        Item.destroy(items_to_trade)
      end

      messages = {}
      if maze_pieces.any?
        messages[:notice] = "#{pluralize(items_to_trade.size, 'item')} traded for #{pluralize(maze_pieces.size, 'maze piece')}."
      end
      if items.size > items_to_trade.size
        messages[:alert] = "#{pluralize(items.size - items_to_trade.size, 'item')} could not be traded for Maze Pieces."
      end
    else
      messages = { alert: 'No items were selected'}
    end

    redirect_to pattern_shop_path, messages
  end

private

  def acceptable_items
    @_acceptable_items ||= ItemTemplate.where(name: [
      'Dreamcatcher', 
      'Feather Headdress', 
      'Mushroom', 
      'Stone Arrowhead', 
      'Pretty Pebble', 
      'Emerald Necklace', 
      'Ornate Vase', 
      'Leaf Charm Necklace', 
      'Bone Flute', 
      'Amethyst Necklace', 
      'Wooden Chair',
      'Lemon Tart'])
  end

  def acceptable_item_ids
    acceptable_items.collect(&:id)
  end

  def maze_piece_ids
    @_maze_piece_ids ||= ItemTemplate.where(category: 'Maze/Tile').collect(&:id)
  end

end
