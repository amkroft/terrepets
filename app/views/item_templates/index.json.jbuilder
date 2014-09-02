json.array!(@item_templates) do |item_template|
  json.extract! item_template, :name, :description, :image, :category
  json.url item_template_url(item_template, format: :json)
end
