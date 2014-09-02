# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

items = {}

#Raw materials
materials = [
  {
    name: 'Iron', 
    category: 'Earth/Mineral',
    value: 25
  },{
    name: 'Silver', 
    category: 'Earth/Mineral',
    value: 28
  }
  # },{
  # REST REDACTED
]

materials.each do |material|
  item = ItemTemplate.find_by(name: material[:name])
  item ||= ItemTemplate.new

  material.each do |k,v|
    item.send("#{k}=",v)
  end
  item.save!

  items[item.name] = item
end

#Craft/smith
item_templates = [
  {
    name: 'Silver Chain',
    category: 'Jewelry',
    value: 33
  },{
    name: 'Wooden Chair',
    category: 'Furniture',
    value: 24
  }
  # },{
  # REST REDACTED
]

item_templates.each do |creation|
  item = ItemTemplate.find_by(name: creation[:name])
  item ||= ItemTemplate.new

  creation.each do |k,v|
    item.send("#{k}=",v)
  end
  item.save!

  items[item.name] = item
end


#StandardPetTemplates
pet_templates = [
  {
    name: 'Blue Dragon',
    description: 'A dark blue drake.'
  },{
    name: 'Grey Kitty',
    description: 'A grey striped kitty.'
  },{
    name: 'Grey Raccoon',
    description: 'A grey raccoon.'
  }
]

pet_templates.each do |template|
  pet_template = StandardPetTemplate.find_by(name: template[:name])
  pet_template ||= StandardPetTemplate.new

  template.each do |k,v|
    pet_template.send("#{k}=",v)
  end
  pet_template.save!
end


#NPC accounts
npcs = [
  {
    username: 'REDACTED',
    password_date: Time.now,
    display_name: 'Pet Shelter',
    money: 0,
    email: 'REDACTED',
    is_npc: true
  },
  {
    username: 'REDACTED',
    password_date: Time.now,
    display_name: 'Banker',
    money: 0,
    email: 'REDACTED',
    is_npc: true
  }
]
npcs.each do |npc|
  user = User.find_by(username: npc[:username])
  user ||= User.new

  npc.each do |k,v|
    user.send("#{k}=",v)
  end
  user.save!(validate: false)
end


#admin accounts
admins = [
  {
    username: 'REDACTED',
    password_date: Time.now,
    encrypted_password: 'REDACTED',
    display_name: 'Onyx',
    email: 'REDACTED',
    is_admin: true
  },{
    username: 'REDACTED',
    password_date: Time.now,
    encrypted_password: 'REDACTED',
    display_name: 'Grimm',
    email: 'REDACTED',
    is_admin: true
  }
]
admins.each do |admin|
  user = User.find_by(username: admin[:username])
  user ||= User.new

  admin.each do |k,v|
    user.send("#{k}=",v)
  end
  user.save!(validate: false)
end


#Forums
forums = [
  {
    name: 'General Chat',
    description: 'Chat about TerrePets stuff with other players.'
  },{
    name: 'Question & Answer',
    description: 'Post any questions you have about how to play TerrePets, or post if you have a helpful answer to a question.'
  },{
    name: 'Commerce',
    description: 'Advertise your store, put a request out for items, or anything else commerce related.'
  },{
    name: 'Graffiti Wall',
    description: 'Share art. Talk about art. Written, drawn, musical. Anything.'
  },{
    name: 'Chit-Chat',
    description: 'Chat about non-TerrePets stuff.'
  },{
    name: 'Game Ideas',
    description: 'Have ideas for how TerrePets could grow and change? Post them here.'
  },{
    name: 'Error Reporting',
    description: 'Report errors, bugs, even bad spelling.'
  },{
    name: 'City Hall',
    description: 'News and discussion on changes to TerrePets.'
  }
]

forums.each do |f|
  forum = Forum.find_by(name: f[:name])
  forum ||= Forum.new

  f.each do |k,v|
    forum.send("#{k}=",v)
  end
  forum.save!
end

#Locations
# LEVEL AND PRIZES REDACTED
locations = [

  {
    name: 'light maple grove',
    level: -1,
    prizes: "REDACTED"
  },{
    name: 'calm meadow',
    level: -1,
    prizes: "REDACTED"
  },{
    name: 'empty cave',
    level: -1,
    prizes: "REDACTED"
  }

  # ADDITIONAL LOCATIONS REDACTED

]

locations.each do |l|
  location = Location.find_by(name: l[:name])
  location ||= Location.new

  l.each do |k,v|
    location.send("#{k}=",v)
  end
  location.save!
end

#Makeables
# DIFFICULTY AND INGREDIENTS REDACTED
makeables = [
  {
    item_template_id: items['Cinnamon Star'].id,
    difficulty: -1,
    ingredients: "REDACTED"
  },{
    item_template_id: items['Leaf Charm Necklace'].id,
    difficulty: -1,
    ingredients: "REDACTED"
  }
  # ADDITIONAL MAKEABLES REDACTED
]

makeables.each do |m|
  makeable = Makeable.find_by(item_template_id: m[:item_template_id])
  makeable ||= Makeable.new

  m.each do |k,v|
    makeable.send("#{k}=",v)
  end
  makeable.save!
end