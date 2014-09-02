module ApplicationHelper

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
