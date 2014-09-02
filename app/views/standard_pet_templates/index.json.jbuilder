json.array!(@standard_pet_templates) do |standard_pet_template|
  json.extract! standard_pet_template, :name, :image, :rights
  json.url standard_pet_template_url(standard_pet_template, format: :json)
end
