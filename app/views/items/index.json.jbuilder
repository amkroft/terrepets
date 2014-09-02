json.array!(@items) do |item|
  json.extract! item, :item_template_id, :user_id
  json.url item_url(item, format: :json)
end
