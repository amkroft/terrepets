json.array!(@pets) do |pet|
  json.extract! pet, :name, :birthday, :gender, :user_id
  json.url pet_url(pet, format: :json)
end
