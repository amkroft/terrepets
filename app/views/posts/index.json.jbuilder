json.array!(@posts) do |post|
  json.extract! post, :content
  json.url post_url(post, format: :json)
end
