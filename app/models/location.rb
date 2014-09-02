class Location < ActiveRecord::Base

  def pretty_prizes
    holder = prizes.split(',')
    pretty_string = ""
    holder.each do |prize_data|
      pretty_string += ", " if !pretty_string.empty?
      prize_data = prize_data.split('|')
      template = ItemTemplate.find(prize_data[0])
      pretty_string += "<a href='item_templates/#{template.id}' target='_blank'>#{template.name}</a>"
      prize_data[1..-1].each do |probability|
        pretty_string += " #{probability}%"
      end
    end
    pretty_string
  end

  def average_food_hours
    holder = prizes.split(',')
    total = 0.0
    holder.each do |prize_data|
      prize_data = prize_data.split('|')
      template = ItemTemplate.find(prize_data[0])
      if template.edible?
        cumulative_prob = 1.0
        prize_data[1..-1].each do |probability|
          cumulative_prob = cumulative_prob * probability.to_i/100.0
          total += template.edible_size * cumulative_prob
        end
      end
    end
    total.round(2)
  end

  def average_game_value
    holder = prizes.split(',')
    total = 0.0
    holder.each do |prize_data|
      prize_data = prize_data.split('|')
      template = ItemTemplate.find(prize_data[0])
      cumulative_prob = 1.0
      prize_data[1..-1].each do |probability|
        cumulative_prob = cumulative_prob * probability.to_i/100.0
        total += template.value * cumulative_prob
      end
    end
    total.round(2)
  end

  # ADDITIONAL LOCATION ID GETTING METHOD REDACTED


  def self.fishing_master_location
    'REDACTED'
  end

  def self.gathering_master_location
    'REDACTED'
  end  

  def self.mining_master_location
    'REDACTED'
  end

  def self.thieving_master_location
    'REDACTED'
  end  

  def self.lumberjacking_master_location
    'REDACTED'
  end

end
