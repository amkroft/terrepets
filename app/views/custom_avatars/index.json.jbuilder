json.array!(@custom_avatars) do |custom_avatar|
  json.extract! custom_avatar, :name, :image, :uploader, :author, :rights
  json.url custom_avatar_url(custom_avatar, format: :json)
end
