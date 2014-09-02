module HourRunnable


  def run_hour(inventory)
    @logs = ""
    @hour_logs = []
    @inventory = inventory
    sleeping ? sleep_hour : awake_hour
    # self.save
    { hour_logs: @hour_logs, logs: @logs }
  end


  def sleep_hour
    puts "Pet #{id} is asleep." if Rails.env.development?

    self.energy += 0 # FORMULA REDACTED
    self.food -= 0 # FORMULA REDACTED

    if 0 # FORMULA REDACTED
      log_message("#{name} woke up.", Rails.env.development?)
      self.sleeping = false
    end
  end


  def awake_hour
    if sleep?
      log_message("#{name} fell asleep.", Rails.env.development?)
      self.sleeping = true
    else
      todos = desires
      todo = todos.max_by{|key,value| value}
      case todo[0]
      when :eat
        puts "Pet #{id} needs to eat." if Rails.env.development?
        succeeded = try_eat
        if !succeeded
          food_attempt = first_food_skill(desires.keys)
          try_outdoor(food_attempt)
        end
      else
        succeeded = try_skill(todo[0])
        skill = todo[0]
        if !succeeded
          todos[todo[0]] = 0
          todo = todos.max_by{|key,value| value}
          try_skill(todo[0])
          skill = todo[0]
        end
        if self.item
          @logs += self.item.reduce_health(0, skill) # FORMULA REDACTED
        end
      end
      self.energy -= 0 # VALUE REDACTED
      self.food -= 0 # VALUE REDACTED
    end
  end


  def try_skill(skill)
    puts "Pet #{id} wants to try #{skill}." if Rails.env.development?
    case skill
    when :gathering, :mining, :lumberjacking, :thieving, :fishing
      try_outdoor(skill)
    when :crafting
      try_craft
    when :eat
      try_eat
    else
      $stderr.puts "Cannot do action '#{skill}'"
      false
    end
  end

  def first_food_skill(todos)
    todos.each do |todo|
      if [:fishing, :hunting, :gathering, :thieving].include? todo
        return todo
      end
    end
  end


  def desires
    equipment = self.item && !self.item.destroyed? ? self.item.item_template : ItemTemplate.new

    desires = {}
    desires[:eat] = 0 # FORMULA REDACTED
    Pet.skills.shuffle.each do |skill|
      dice = skill_dice(skill)
      equip = equipment.send("equip_#{skill}")
      desires[skill] = dice + equip
    end

    desires
  end


  def try_eat
    count = 0
    eaten = []
    eaten_names = []
    @inventory.each do |item|
      info = item.item_template
      if info.edible
        # IF STATEMENT REDACTED
        # SUBSTITUTED:
        self.food += info.edible_size

        count += 1
        # puts "Pet #{id} ate #{info.name}." if Rails.env.development?
        # @logs += "#{name} ate #{info.name}.<br>"
        eaten_names << info.name
        eaten << item
      end
      if self.food >= max_food || count >= 3
        self.food = [self.food,max_food].min
        break
      end
    end
    remove_items(eaten)
    # Item.delete(eaten)

    if count == 0
      log_message("#{name} could not find anything to eat.", Rails.env.development?, 'red')
      false
    else
      log_message("#{name} ate #{eaten_names.join(', ')}.", Rails.env.development?)
      true
    end
  end


  def try_outdoor(skill)
    success_dice = skill_dice(skill)
    upper_bound = 0 # FORMULA REDACTED
    lower_bound = 0 # FORMULA REDACTED
    puts "#{skill} success_dice : #{success_dice}" if Rails.env.development?

    locations = Location.where("level <= ? AND level >= ? AND category = ?", upper_bound, lower_bound, skill).order('RAND()').to_a
    locations << nil if Terrepets::TrueRandom.rand < 0 # FORMULA REDACTED
    location = locations.sample

    if !location.nil?

      puts "Pet #{id} is #{skill} #{location.preposition} #{location.article} #{location.name}." if Rails.env.development?
      treasures = location.prizes.split(',')
      prizes = []

      treasures.each do |treasure|
        data = treasure.split('|')
        data[1..-1].each do |probability|
          if Terrepets::TrueRandom.rand < probability.to_i
            prizes << data[0]
          else
            break
          end
        end
      end

      holiday_finds.each do |item_template|
        if 0 # FORMULA REDACTED
          prizes << item_template.id
        end
      end

      prizes += equip_finds(location)

      if prizes.any?
        prize_text = ""
        # db_inserts = []
        items_to_create = []
        candy_heart_id = ItemTemplate.find_by(name: 'Candy Heart').id
        prize_template_hash = Hash[ *ItemTemplate.find(prizes).collect { |prize_template| [ prize_template.id, prize_template ] }.flatten ]

        prizes.each do |prize_id|
          origin_note = "#{name} #{skill_past_tense(skill)} this from #{location.article} #{location.name}."
          puts "Pet #{id} found item #{prize_id}." if Rails.env.development?
          user_note = prize_id == candy_heart_id ? vday_random_note : nil
          durability = prize_template_hash[prize_id.to_i].durability ? prize_template_hash[prize_id.to_i].durability : nil
          
          items_to_create << {user_id: user_id, item_template_id: prize_id, origin_note: origin_note, user_note: user_note, health: durability}
          prize_text += "#{prize_template_hash[prize_id.to_i].name}, "
        end

        create_items(items_to_create)

        prize_text.chomp!(", ")
        log_message("#{name} #{skill_past_tense(skill)} #{location.preposition} #{location.article} #{location.name} and found #{prize_text}.", false, 'green')
        increase_stats(skill, success_dice)
        check_mastery(location, prizes)
        true
      else
        puts "Pet #{id} did not find any items." if Rails.env.development?
        log_message("#{name} #{skill_past_tense(skill)} #{location.preposition} #{location.article} #{location.name} but did not find anything.", false, 'blue')
        self.send("#{skill}_train", 1)
        true
      end
    else
      puts "Pet #{id} failed to find a location to #{skill_present_tense(skill)}." if Rails.env.development?
      log_message("#{name} went out to #{skill_present_tense(skill)} but could not find anywhere to #{skill_present_tense(skill)}.", false, 'red')
      self.send("#{skill}_train", 1)
      false
    end
  end


  def try_craft
    success_dice = skill_dice(:crafting)
    upper_bound = 0 # FORMULA REDACTED
    # TODO add this limit back in when there are more crafts
    # lower_bound = 0 # FORMULA REDACTED
    lower_bound = 0 # VALUE REDACTED
    puts "Crafting success_dice : #{success_dice}" if Rails.env.development?

    crafts = Makeable.includes(:item_template).where("difficulty <= ? AND difficulty >= ?",upper_bound, lower_bound).order('RAND()').take(5)
    # TODO something similar to locations where there's a nil craft for failure to decide on a craft
    crafted_something = false

    crafts.each do |craft|
      items = can_make(craft.ingredients)
      if items
        puts "Pet #{id} made item #{craft.item_template.name}." if Rails.env.development?
        log_message("#{name} made #{craft.item_template.name}.", false, 'green')
        
        # new_item = Item.new({:user_id => user_id, :item_template_id => craft.item_template_id, origin_note: "#{name} crafted this item."})
        # new_item.save
        create_items([{:user_id => user_id, :item_template_id => craft.item_template_id, origin_note: "#{name} crafted this item."}])

        # items.each(&:destroy)
        remove_items(items)

        crafted_something = true
        break
      else
        puts "Pet #{id} wanted to make #{craft.item_template.name} but did not find enough materials." if Rails.env.development?
      end
    end

    if !crafted_something
      if crafts.any?
        puts "Pet #{id} could not find enough materials to craft anything." if Rails.env.development?
        log_message("#{name} wanted to make #{crafts.last.item_template.name} but did not find enough materials.", false, 'blue')
        crafting_train 1
        false
      else
        puts "No items found for pet #{id} to craft." if Rails.env.development?
        log_message("#{name} wanted to craft something but could not decide on anything.", false, 'blue')
        crafting_train 1
        false
      end
    else
      # TODO Should this be the upper_bound?
      increase_stats(:crafting, success_dice)
      true
    end
  end


  def can_make(ingredients)
    new_ingredients = {}
    total_needed = 0
    ingredients.split(',').each do |ingredient|
      ingredient = ingredient.split('|')
      new_ingredients[ingredient[0].to_i] = ingredient[1].to_i
      total_needed += ingredient[1].to_i
    end

    used_items = []
    total_left = total_needed
    @inventory.each do |item|
      if new_ingredients.has_key?(item.item_template_id) && new_ingredients[item.item_template_id] > 0
        used_items += [item]
        new_ingredients[item.item_template_id] -= 1
        total_left -= 1
      end
      break if total_left == 0
    end

    return used_items if used_items.size == total_needed
    nil
  end


private


  def sleep?
    # REDACTED
    false
  end


  def desire_to_eat
    # REDACTED
    0
  end


  def skill_dice(skill)
    # REDACTED
    0
  end


  def successes(dice)
    # REDACTED
    0
  end


  def holiday_finds
    items = []
    # REDACTED
    items
  end 

  def equip_finds(location)
    # REDACTED
    []
  end

  def vday_random_note
    ['It\'s Love','Be True','For You','So Fine','Hug Me','Hug','Smile','You Rule','Be Mine','Be Good','Ur Kind','Be Happy','I <3 U'].sample
  end

  def check_mastery(location, prizes)
    Pet.outdoor_skills.each do |skill|
      master_location = Location.send("#{skill}_master_location")
      mastery = "master_#{Pet.skill_noun[skill]}"
      if !self.send(mastery) && location.name == master_location && prizes.include?(ItemTemplate.mastery_item_id(skill).to_s)
        self.send("#{mastery}=", true)
        self.pet_badge.send("#{mastery}=", true) if !self.pet_badge.send(mastery)
        self.pet_badge.save
        log_message("#{self.name} has become a Master #{Pet.skill_noun[skill].capitalize}!", true, 'purple')
      end
    end
  end


  def log_message(message, puts_log = false, font_color = nil, real_time = false)
    puts message if puts_log
    message = "<font color='#{font_color}'>#{message}</font>" if font_color
    @logs += message + "<br>"
    @hour_logs << {pet_id: id, description: message, real_time: real_time}
  end

  def create_items(item_hashes)
    Item.transaction do
      item_hashes.each do |item_hash|
        holder = Item.create(item_hash)
        @inventory << holder
        # db_inserts << "(#{holder.user_id}, #{holder.item_template_id}, #{ActiveRecord::Base.connection.quote(origin_note)}, #{user_note}, #{ActiveRecord::Base.connection.quote(Time.now)}, #{ActiveRecord::Base.connection.quote(Time.now)}, #{durability})"
      end
    end
    # sql = "INSERT INTO items (`user_id`, `item_template_id`, `origin_note`, `user_note`, `created_at`, `updated_at`, `health`) VALUES #{db_inserts.join(", ")}"
    # Item.connection.execute(sql)
  end

  def remove_items(items)
    Item.delete(items)
    items.each do |item|
      @inventory.delete(item)
    end
  end

end
