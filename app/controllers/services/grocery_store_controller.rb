class Services::GroceryStoreController < ApplicationController

  def index
    orange = ItemTemplate.find_by(:name => 'Orange')
    garlic = ItemTemplate.find_by(:name => 'Garlic')
    butter = ItemTemplate.find_by(:name => 'Butter')
    # sugar = ItemTemplate.find_by(:name => 'Sugar')
    @item_templates = [orange, garlic, butter]
  end

  def buy
    total_cost = 0
    params[:template_ids].each_with_index do |template_id, index|
      template = ItemTemplate.find(template_id)
      total_cost += (template.value * 1.2).to_i * params[:quantities][index].to_i
    end
    if total_cost > current_user.money
      message = { alert: 'You do not have enough monies for the selected items.'}
    else
      current_user.update_attribute(:money, current_user.money - total_cost)
      total = 0
      params[:template_ids].each_with_index do |template_id, index|
        params[:quantities][index].to_i.times do
          Item.create({item_template_id: template_id, location: 2, user_id: current_user.id, user_note: 'Bought from the Grocery Store.'})
          total += 1
        end
      end
      message = { notice: "#{pluralize(total,'item')} bought.  Find them in your Incoming." }
    end
    redirect_to grocery_store_path, message
  end

end