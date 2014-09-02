json.array!(@makeables) do |makeable|
  json.extract! makeable, :id, :difficulty, :item_template_id, :ingredients
  json.url makeable_url(makeable, format: :json)
end
