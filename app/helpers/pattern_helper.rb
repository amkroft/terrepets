module PatternHelper

  def direction_text(tiles, keys, direction, user)
    if !tiles.has_key?(keys[direction]) && tiles[keys[:central]].send("#{direction}_open")
      link_to "#{direction.to_s.capitalize} - Place Tile", place_tile_path(user.x, user.y, direction)
    elsif tiles.has_key?(keys[direction]) && tiles[keys[direction]].send("#{opposite_direction(direction)}_open") && tiles[keys[:central]].send("#{direction}_open")
      if tiles[@keys[direction]].has_obstacle
        text = "#{direction.to_s.capitalize} - Obstacle: #{@pattern_tiles[@keys[direction]].obstacle.name}"
      else
        text = "#{direction.to_s.capitalize} - Move"
      end
      link_to text, pattern_user_move_path(direction)
    else
      "#{direction.to_s.capitalize} - No Action"
    end
  end

private

  def opposite_direction(direction)
    case direction
    when :north
      :south
    when :east
      :west
    when :south
      :north
    when :west
      :east
    else
      :unknown
    end
  end

  def direction_to_s(direction)
    direction.to_s.capitalize
  end

  def place_tile_path(x, y, direction)
    case direction
    when :north
      place_pattern_tile_path(x: x, y: y + 1)
    when :east
      place_pattern_tile_path(x: x + 1, y: y)
    when :south
      place_pattern_tile_path(x: x, y: y - 1)
    when :west
      place_pattern_tile_path(x: x - 1, y: y)
    end
  end

end