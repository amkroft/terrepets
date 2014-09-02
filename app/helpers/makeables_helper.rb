module MakeablesHelper

  def pretty_ingredients(ingredients)
    holder = ingredients.split(',')
    pretty_string = ""
    holder.each do |ingredient_data|
      pretty_string += ", " if !pretty_string.empty?
      ingredient_data = ingredient_data.split('|')
      pretty_string += ingredient_data[1]
      pretty_string += "  "
      begin
        template = ItemTemplate.find(ingredient_data[0])
        pretty_string += link_to template.name, item_template_path(template)
      rescue ActiveRecord::RecordNotFound => e
        pretty_string += "XXX"
      end
    end
    pretty_string
  end

end
