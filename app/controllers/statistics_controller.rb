class StatisticsController < ApplicationController

  def index
    @counts = {}
    @counts['Users'] = User.count
    @counts['Pets'] = Pet.count

    @counts['Male Pets'] = Pet.where(gender: Pet.genders[:male]).count
    @counts['Female Pets'] = Pet.where(gender: Pet.genders[:female]).count
    
    @counts['Custom Pets'] = Pet.where(pet_template_type: 'CustomPetTemplate').count
    @counts['Items'] = ItemTemplate.count
    @counts['Locations'] = Location.count
    @counts['Makeables'] = Makeable.count
    @counts['Recipes'] = Recipe.count
    @counts['Threads'] = Topic.count
    @counts['Posts'] = Post.count
    @counts['Favor'] = User.sum(:favor)

    @averages = {}
    @averages['Pets per User'] = (@counts['Pets'].to_f/@counts['Users']).round(2)
    @averages['Items per User'] = (Item.count.to_f/@counts['Users']).round(2)
    @averages['Money per User'] = (total_monies/@counts['Users']).round(2)

    @other = {}
    @other['Highest Level Pet'] = Pet.highest_level
    @other['Average Pet Level'] = Pet.average_level
    @other['Total Monies'] = total_monies.to_i
    @other['Total Stars Placed'] = Post.sum(:stars)
    @other['Users Active in Last 48 Hours'] = User.where('last_active > ?', Time.now - 48.hours).count
    @other['New Users in Last Week'] = User.where('created_at > ?', Time.now - 1.week).count
    @other['Total Gifted Items'] = UserStatistic.sum(:gifted_items)
  end

  def giving_tree
    @total_gifted = UserStatistic.sum(:gifted_items)
    # top_gift_stats = UserStatistic.order('gifted_item_total DESC').take(15)
    # @top_gifters = User.includes(find(top_gift_stats.map(&:user_id))
    # @top_gifters = User.order('gifted_item_total DESC').take(15)

    @top_gifters = User.joins(:user_statistic).order('user_statistics.gifted_items DESC').take(15)
  end

  def pattern
    @stats = {}
    @stats[:maze_pieces_placed] = UserStatistic.sum(:maze_pieces_placed)
    @stats[:pattern_obstacles_cleared] = UserStatistic.sum(:pattern_obstacles_cleared)

    @top_placers = User.joins(:user_statistic).order('user_statistics.maze_pieces_placed DESC').take(10)
    @top_clearers = User.joins(:user_statistic).order('user_statistics.pattern_obstacles_cleared DESC').take(10)
  end

  def recycling
    @stats = {}
    @stats[:items_recycled] = UserStatistic.sum(:items_recycled)
    @stats[:items_received_from_recycling] = UserStatistic.sum(:items_received_from_recycling)

    @top_recyclers = User.joins(:user_statistic).order('user_statistics.items_recycled DESC').take(10)
  end

private

  def total_monies
    User.sum(:money) + User.sum(:savings)
  end

end