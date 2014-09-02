class ItemTemplate < ActiveRecord::Base
  validates_uniqueness_of :name

  include Imageable

  has_many :items
  has_many :makeables

  before_destroy :delete_image

  self.per_page = 20
	
  def image
    "items/#{ActiveSupport::Inflector.underscore(name)}.png"
  end

  def self.image(name)
    "items/#{ActiveSupport::Inflector.underscore(name)}.png"
  end

  def image_availability
    nil
  end

  def image_type
    'items'
  end

  def recyclable?
    !(recycle_ingredients.nil? || recycle_ingredients.empty?)
  end

  # ADDITONAL ITEM ID GETTING METHOD REDACTED

  def self.mastery_items
    {
      fishing: 'REDACTED',
      gathering: 'REDACTED',
      mining: 'REDACTED',
      thieving: 'REDACTED',
      lumberjacking: 'REDACTED'
    }
  end

  def self.mastery_item_id(skill)
    id = self.class.instance_variable_get("@_#{skill}_mastery_item_id")
    if !id
      id = nil
    end

    if !id
      holder = self.find_by(name: self.mastery_items[skill])
      if holder
        id = holder.id
      else
        id = 0
      end
    end

    self.class.instance_variable_set("@_#{skill}_mastery_item_id", id)
    id
  end

end
