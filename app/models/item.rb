class Item < ActiveRecord::Base

  belongs_to :user
  belongs_to :item_template
  belongs_to :pet

  self.per_page = 25

  before_create :set_health

  # validates :price, numericality: { only_integer: true }
  # TODO This is the upper limit for a signed int.  Maybe make this an unsigned int?
  # validates :price, numericality: { less_than_or_equal_to: 2147483647 }

  def set_health
    if self.health.nil?
      self.health = item_template.durability
    end
  end

  def self.locations
    ['My House','My Store','Incoming','Equipped','In Trade']
  end

  def durability_text
    'REDACTED'
  end

  def worn
    # REDACTED
    false
  end

  def reduce_health(destruction, activity)
    return "" if destroyed?
    self.health -= destruction
    pet = self.pet
    if self.health <= 0
      rubble_template = ItemTemplate.find_by(name: 'Rubble')
      Item.transaction do
        Item.create({item_template: rubble_template, location: 0, user_id: self.user_id, origin_note: "This #{self.item_template.name} was ruined while #{activity}."})
        self.destroy
      end
      "<font color='red'>#{self.item_template.name} was destroyed.  #{pet.name} dropped the remains in your House.</font><br>"
    else
      self.save
      ""
    end
  end

  def sort_note
    note = origin_note.to_s + " " + user_note.to_s
    note.lstrip.downcase
  end

  def recently_acquired
    updated_at > (Time.now - 5.minutes)
  end
  
end
