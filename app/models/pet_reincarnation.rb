class PetReincarnation < ActiveRecord::Base

  belongs_to :pet

  serialize :masteries, Array

  def pretty_masteries
    holder = ''
    masteries.each_with_index do |mastery, index|
      holder += mastery.split[1].downcase
      if index == masteries.size - 2 && masteries.size == 2
        holder += ' and '
      elsif index == masteries.size - 2
        holder += ', and '
      elsif index < masteries.size - 1
        holder += ', '
      end
    end
    holder
  end

end