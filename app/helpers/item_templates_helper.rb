module ItemTemplatesHelper

  def meal_size(item_template, pet)
    ratio = pet.max_food/item_template.edible_size
    'REDACTED'
  end

  def durability_text(durability)
    'REDACTED'
  end

  def equipment_bonus_text(skill_bonus, skill)
    'REDACTED'
  end

end
