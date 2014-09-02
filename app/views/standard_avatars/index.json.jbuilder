json.array!(@standard_avatars) do |standard_avatar|
  json.extract! standard_avatar, :name, :image, :rights
  json.url standard_avatar_url(standard_avatar, format: :json)
end
