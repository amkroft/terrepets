json.array!(@custom_pet_templates) do |custom_pet_template|
  json.extract! custom_pet_template, :name, :image, :uploader, :recipient, :author, :rights
  json.url custom_pet_template_url(custom_pet_template, format: :json)
end
