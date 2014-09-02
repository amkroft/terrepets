json.array!(@locations) do |location|
  json.extract! location, :id, :name, :level, :prizes, :category
  json.url location_url(location, format: :json)
end
