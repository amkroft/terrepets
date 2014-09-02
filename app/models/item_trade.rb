class ItemTrade < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => :user_1_id
  belongs_to :recipient, :class_name => "User", :foreign_key => :user_2_id

  serialize :item_1_ids, Array
  serialize :item_2_ids, Array

  # status: 0 => not completed or canceled, 1 => canceled, 2 => completed

  def other_user(user_id)
    if user_1_id == user_id
      user_2_id
    else
      user_1_id
    end
  end


  def money_receiving(user)
    if user.id == user_1_id
      self.money_2
    elsif user.id == user_2_id
      self.money_1
    else
      0
    end
  end

  def money_sending(user)
    if user.id == self.user_1_id
      self.money_1
    elsif user.id == self.user_2_id
      self.money_2
    else
      0
    end
  end

  def items_receiving(user)
    if user.id == self.user_1_id
      self.item_2_ids
    elsif user.id == self.user_2_id
      self.item_1_ids
    else
      []
    end
  end

  def items_sending(user)
    if user.id == self.user_1_id
      self.item_1_ids
    elsif user.id == self.user_2_id
      self.item_2_ids
    else
      []
    end
  end

  def sending_description(user)
    if user.id == self.user_1_id
      self.description_1 || ""
    elsif user.id == self.user_2_id
      self.description_2 || ""
    else
      ""
    end
  end

  def receiving_description(user)
    if user.id == self.user_1_id
      self.description_2 || ""
    elsif user.id == self.user_2_id
      self.description_1 || ""
    else
      ""
    end
  end

  def anonymous_for(user)
    self.user_1_id != user.id && self.anonymous
  end


  def set_items(item_ids, user)
    puts "Hit set_items with: #{item_ids}"
    if user.id == self.user_1_id
      self.item_1_ids = item_ids
    elsif user.id == self.user_2_id
      self.item_2_ids = item_ids
    end
  end


  def completed
    self.status == 2
  end

  def canceled
    self.status == 1
  end


  def set_description(user, description)
    if user.id == self.user_1_id
      self.description_1 = description
    elsif user.id == self.user_2_id
      self.description_2 = description
    end
  end

end