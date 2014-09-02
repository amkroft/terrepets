module HouseHelper

  def feed_pet_options(pets)
    options = ""
    pets.each do |pet|
      if !pet.sleeping
        options += "<option value=\"#{pet.id}\">#{pet.name} - #{pet.food_note}</option>\n"
      end
    end
    options.html_safe
  end

end
