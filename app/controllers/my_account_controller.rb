class MyAccountController < ApplicationController

	def index
		@user = current_user
	end

  def avatar
    @standard_avatars = StandardAvatar.all
  end

  def custom_avatar
    # Check user has enough Favor
  end

  def update_avatar
    current_user.avatar_type = 'StandardAvatar'
    current_user.avatar_id = params['avatar']
    current_user.save
    redirect_to my_account_avatar_path, {notice: 'Avatar changed!'}
  end


  def stats
    user_stats = UserStatistic.find_by(user_id: current_user.id) || UserStatistic.create(user_id: current_user.id)
    @stats = {}
    @stats[:total_store_sales] = StoreTransaction.where(user_id: current_user.id).sum(:amount).to_s + " money"
    # @stats[:stars_received] = pluralize(Post.where(user_id: current_user.id).sum(:stars).to_s, 'star')
    @stats[:stars_received] = pluralize(StarLog.where(author_id: current_user.id).sum(:count).to_s, 'star')
    @stats[:signed_up] = current_user.created_at.strftime("%D %r")
    @stats[:gifted_items] = pluralize(user_stats.gifted_items.to_s, 'item')
    @stats[:maze_pieces_placed] = pluralize(user_stats.maze_pieces_placed.to_s, 'maze piece')
    @stats[:hand_fet_pets] = pluralize(user_stats.hand_fet_pets, 'time')
    @stats[:money_from_gameselling] = user_stats.money_from_gameselling.to_s + ' money'
    @stats[:items_gamesold] = pluralize(user_stats.items_gamesold.to_s, 'item')
    @stats[:items_recycled] = pluralize(user_stats.items_recycled.to_s, 'item')
    @stats[:items_from_recycling] = pluralize(user_stats.items_received_from_recycling.to_s, 'item')
    @stats[:pattern_obstacles_cleared] = pluralize(user_stats.pattern_obstacles_cleared.to_s, 'obstacle')
  end


  def profile
  end

  def update_profile
    current_user.profile = params[:user][:profile]
    if current_user.save
      redirect_to user_path(current_user), { notice: "Profile updated" }
    else
      redirect_to my_account_profile_path, { alert: "Profile was not successfully saved" }
    end
  end

end