class Pet < ActiveRecord::Base

	belongs_to :user
  belongs_to :pet_template, polymorphic: true

  has_one :item
  has_many :hour_logs
  has_many :pet_reincarnations
  has_one :pet_badge

  enum gender: { female: false, male: true }

  self.per_page = 25

  before_create :randomize_skills
  after_create :create_pet_badge

  include HourRunnable

  def self.pet_shelter_pets
    puts "Running Pet.pet_shelter_pets"
    pets = Pet.where(user_id: User.shelter_user_id)
    puts "#{pets.size} pets in the Shelter."

    # Remove old pets
    released_pets = 0
    pets.each do |pet|
      if pet.updated_at < Time.now - 1.week
        pet.destroy
        released_pets += 1
      end
    end
    puts "#{released_pets} pets released to the wild."

    # Generate new pets
    leftover_pets = pets.size - released_pets
    created_pets = (10 - leftover_pets)
    if leftover_pets < 10
      (10 - leftover_pets).times { generate_pet(User.shelter_user_id) }
    end
    puts "#{created_pets} pets created."
  end

  def self.generate_pet(user_id)
    user = User.find(user_id)
    randgender = Terrepets::TrueRandom.rand_range(0,1)
    type = randgender == 0 ? 'goddess' : 'gods'
    file = File.join(Rails.root, 'lib', 'assets', "#{type}.txt")
    name = File.readlines(file).sample.strip

    template = StandardPetTemplate.all.sample
    return if template.nil?
    pet = Pet.new
    pet.update_attributes({
        :gender => (randgender == 1), 
        :birthday => Time.now, 
        :name => name, 
        :pet_template_type => 'StandardPetTemplate', 
        :pet_template_id => template.id,
        :user_id=> user_id
      })
    pet
  end


  def randomize_skills
    # REDACTED
  end

  def reset_masteries
    Pet.master_types.each do |master_type|
      self.send("#{master_type}=", false)
    end
  end

  def reset_skills
    Pet.skills.each do |skill|
      self.send("#{skill}=", 0)
      self.send("#{skill}_training=", 0)
    end

    Pet.minor_skills.each do |minor_skill|
      self.send("#{minor_skill}=", 0)
      self.send("#{minor_skill}_training=", 0)
    end
  end


  def self.adopt_limit
    12
  end

  def level
    level = 0
    Pet.skills.each do |skill|
      level += self.send(skill).to_i
    end
    Pet.minor_skills.each do |skill|
      level += self.send(skill).to_i
    end
    level
  end

  def self.highest_level
    self.level_stats('MAX')
  end

  def self.average_level
    self.level_stats('AVG')
  end

  def self.level_stats(function)
    skill_string = self.skills.map { |skill| "FLOOR(#{skill})" }
    skill_string += self.minor_skills.map { |skill| "FLOOR(#{skill})" }
    sql = "SELECT #{function}(#{skill_string.join(' + ')}) FROM pets;"

    result = Item.connection.execute(sql)
    result.first[0].to_i
  end


  def self.master_types
    [:master_crafter, :master_fisher, :master_gatherer, :master_lumberjack, :master_miner, :master_thief]
  end

  def masteries
    set_masteries
    @_masteries.join(', ')
  end

  def masteries_array
    set_masteries
    @_masteries
  end

  def set_masteries
    @_masteries ||= nil
    if !@_masteries
      @_masteries = []
      Pet.master_types.each do |master_type|
        if self.send(master_type)
          @_masteries << ActiveSupport::Inflector.titleize(master_type)
        end
      end
    end
  end

  def can_reincarnate?
    !masteries_array.nil? && !masteries_array.empty?
  end


  %w(lumberjacking thieving wits athletics crafting dexterity gathering intelligence perception stamina strength survival mining smithing stealth fishing).each do |name|
    define_method name do
      read_attribute(name).to_i
    end

    define_method "#{name}=" do |value|
      if value.is_a? Numeric
        value = value.to_i
        old_attribute = read_attribute(name)
        old_training = level_stat_exp(old_attribute.to_i) * old_attribute.modulo(1)
        new_stat = level_stat_exp(value)
        old_training = [old_training.to_i,new_stat-1].min

        new_training = old_training.to_f/new_stat

        value = value + new_training
        write_attribute(name, value)
      else
        raise TypeError, "Method #{name}= expects a numeric, but a #{value.class.name} was given."
      end
    end

    define_method "#{name}_training" do
      attribute = read_attribute(name)
      points = attribute.modulo(1)
      (level_stat_exp(attribute.to_i) * points).to_i
    end

    define_method "#{name}_training=" do |value|
      if value.is_a? Numeric
        old_attribute = read_attribute(name)
        level_stats = level_stat_exp(old_attribute.to_i)

        new_training = ([value,level_stats-1].min).to_f / level_stats
        new_attribute = old_attribute.to_i + new_training.to_f
        write_attribute(name, new_attribute)
      else
        raise TypeError, "Method #{name}_training= expects a numeric, but a #{value.class.name} was given."
      end
    end

    define_method "#{name}_train" do |value|
      if value.is_a? Numeric
        value = value.ceil if value.is_a? Float
        puts "Training #{name} stat with value #{value}" if Rails.env.development?
        old_attribute = read_attribute(name)
        new_attribute = (old_attribute + (value.to_f/level_stat_exp(old_attribute.to_i))).round(4)
        write_attribute(name, new_attribute)
        puts self.errors.to_a
        if old_attribute.to_i < new_attribute.to_i
          @logs += "<font color='purple'>#{self.name} leveled up in #{name}!</font><br>"
          @hour_logs << { pet_id: id, description: "<font color='purple'>#{self.name} leveled up in #{name}!</font>", real_time: false } 
        end
      else
        raise TypeError, "Method #{name}_train expects a numeric, but a #{value.class.name} was given."
      end
    end

  end


  def energy_note
    'REDACTED'
  end

  def food_note
    'REDACTED'
  end

  def safety_note
    'REDACTED'
  end
  def safety
    # REDACTED
    0
  end
  def max_safety
    # REDACTED
    0
  end

  def love_note
    'REDACTED'
  end
  def love
    # REDACTED
    0
  end
  def max_love
    # REDACTED
    0
  end

  def esteem_note
    'REDACTED'
  end
  def esteem
    # REDACTED
    0
  end
  def max_esteem
    # REDACTED
    0
  end


  def level_stat_exp(x)
    # REDACTED
    0
  end

  def max_energy
    # REDACTED
    0
  end

  def max_food
    # REDACTED
    0
  end


  def self.skills
    [:crafting, :fishing, :gathering, :mining, :thieving, :lumberjacking]
  end

  def self.outdoor_skills
    [:fishing, :gathering, :mining, :thieving, :lumberjacking]
  end

  def self.indoor_skills
    [:crafting]
  end

  def self.skill_noun
    {
      crafting: :crafter,
      fishing: :fisher,
      gathering: :gatherer,
      mining: :miner,
      thieving: :thief,
      lumberjacking: :lumberjack
    }
  end

  def self.minor_skills
    [:athletics, :dexterity, :intelligence, :perception, :stamina, :stealth, :strength, :wits]
  end

private

  def create_pet_badge
    PetBadge.create(pet_id: self.id)
  end

  
  def increase_stats(skill, dice)
    # REDACTED
  end

  def stats
    {
      redacted: ['REDACTED']
    }
  end


  def article_it(string)
    if ['a','e','i','o','u'].include? string.chars.first
      string = "an #{string}"
    elsif string =~ /^[A-Z]+/
      string = "the #{string}"
    else
      string = "a #{string}"
    end
    string
  end

  def skill_past_tense(skill)
    tenses = {
      gathering: 'gathered',
      mining: 'mined',
      lumberjacking: 'lumberjacked',
      thieving: 'thieved',
      hunting: 'hunted',
      crafting: 'crafted',
      smithing: 'forged',
      fishing: 'fished'
    }
    tenses[skill]
  end

  def skill_present_tense(skill)
    tenses = {
      gathering: 'gather',
      mining: 'mine',
      lumberjacking: 'lumberjack',
      thieving: 'thieve',
      hunting: 'hunt',
      crafting: 'craft',
      smithing: 'forge',
      fishing: 'fish'
    }
    tenses[skill]
  end

end
  