json.array!(@forums) do |forum|
  json.extract! forum, :name, :description
  json.url forum_url(forum, format: :json)
end
