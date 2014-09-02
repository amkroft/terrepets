module TradingPostHelper

  def item_trade_text(current_user, item_trade)
    puts "ItemTrade #{item_trade.id} has #{item_trade.item_1_ids.size} item 1 ids and #{item_trade.item_2_ids.size} item 2 ids"

    text = {sending: "", receiving: ""}
    sending_items = []
    receiving_items = []

    if item_trade.user_1_id == current_user.id
      text[:sending] = item_trade.money_1.to_s + " monies<br>" if item_trade.money_1 > 0
      sending_items = Item.includes(:item_template).find(item_trade.item_1_ids) if item_trade.item_1_ids
      text[:receiving] = item_trade.money_2.to_s + " monies<br>" if item_trade.money_2 > 0
      receiving_items = Item.includes(:item_template).find(item_trade.item_2_ids) if item_trade.item_2_ids
    else
      text[:receiving] = item_trade.money_1.to_s + " monies<br>" if item_trade.money_1 > 0
      receiving_items = Item.includes(:item_template).find(item_trade.item_1_ids) if item_trade.item_1_ids
      text[:sending] = item_trade.money_2.to_s + " monies<br>" if item_trade.money_2 > 0
      sending_items = Item.includes(:item_template).find(item_trade.item_2_ids) if item_trade.item_2_ids
    end

    puts "sending_items: #{sending_items}"
    puts "receiving_items: #{receiving_items}"

    # Sent items
    sent_items_hash = {}
    sending_items.each do |item|
      if sent_items_hash.has_key? item.item_template.name
        sent_items_hash[item.item_template.name][:quantity] += 1
        sent_items_hash[item.item_template.name][:ids] << item.id
      else
        sent_items_hash[item.item_template.name] = {ids: [item.id], quantity: 1}
      end
    end

    puts "sent_items_hash: #{sent_items_hash}"
    sent_items_hash.keys.sort.each do |item_name|
      link = link_to item_name, item_encyclopedia_path(item_name.gsub(/ /, '_').downcase), target: '_blank'
      text[:sending] += "#{sent_items_hash[item_name][:quantity]}x #{link}<br>"
    end
    text[:sending].chomp('<br>') if text[:sending]

    # Recieved items
    received_items_hash = {}
    receiving_items.each do |item|
      if received_items_hash.has_key? item.item_template.name
        received_items_hash[item.item_template.name][:quantity] += 1
        received_items_hash[item.item_template.name][:ids] << item.id
      else
        received_items_hash[item.item_template.name] = {ids: [item.id], quantity: 1}
      end
    end

    puts "received_items_hash: #{received_items_hash}"
    received_items_hash.keys.sort.each do |item_name|
      link = link_to item_name, item_encyclopedia_path(item_name.gsub(/ /, '_').downcase), target: '_blank'
      text[:receiving] += "#{received_items_hash[item_name][:quantity]}x #{link}<br>"
    end
    text[:receiving].chomp('<br>') if text[:receiving]


    text

  end

end