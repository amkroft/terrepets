class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    can :read, [Pet, User]

    if user
        can [:edit, :update, :unequip, :equip, :update_equip, :profile, :hour_logs], Pet, :user_id => user.id 
        can [:reincarnation, :reincarnate], Pet do |pet|
            pet.can_reincarnate? && pet.user_id == user.id
        end

        can :update, User, id: user.id
        can :profile, User, id: user.id

        # Abilities for Forum
        can :create, [Topic, Post]
        # cannot [:new, :create], Topic, :forum_id => 9
        can :update, [Topic, Post], :user_id => user.id
        can :read, [Forum, Topic, Post]
        can :irc, Forum

        # Abilities for ItemTrades
        can :create, ItemTrade
        can [:read, :cancel], ItemTrade do |item_trade|
            item_trade.user_1_id == user.id || item_trade.user_2_id == user.id
        end
        can :accept, ItemTrade do |item_trade|
            (item_trade.user_1_id == user.id && item_trade.negotiated) || (item_trade.user_2_id == user.id && item_trade.gift)
        end
        can [:negotiate, :process_negotiation], ItemTrade do |item_trade|
            !item_trade.negotiated && (item_trade.user_2_id == user.id) && !item_trade.gift
        end
    end

    if user && user.is_admin
        can :manage, :all
        cannot :cancel, ItemTrade do |item_trade|
            item_trade.user_1_id != user.id && item_trade.user_2_id != user.id
        end
        cannot :accept, ItemTrade do |item_trade|
            (item_trade.user_1_id != user.id || !item_trade.negotiated) && (item_trade.user_2_id != user.id || !item_trade.gift)
        end
        cannot [:negotiate, :process_negotiation], ItemTrade do |item_trade|
            item_trade.negotiated || (item_trade.user_2_id != user.id) || item_trade.gift
        end
    end

  end
end
