class PatternController < ApplicationController

  def index
    if current_user.pattern_user
      @pattern_user = current_user.pattern_user
    else
      random_tile = PatternTile.where(obstacle_id: nil).order('RAND()').first
      @pattern_user = PatternUser.create({user_id: current_user.id, x: random_tile.x, y: random_tile.y})
    end
    @pattern_tiles = @pattern_user.surrounding_tiles
    key = "#{@pattern_user.x}-#{@pattern_user.y}".to_sym
    @pattern_tiles[key].text_tile.gsub!(/Y/,"</font>O<font color='white'>")
    @keys = {
      central: "#{@pattern_user.x}-#{@pattern_user.y}".to_sym,
      north: "#{@pattern_user.x}-#{@pattern_user.y+1}".to_sym,
      east: "#{@pattern_user.x+1}-#{@pattern_user.y}".to_sym,
      south: "#{@pattern_user.x}-#{@pattern_user.y-1}".to_sym,
      west: "#{@pattern_user.x-1}-#{@pattern_user.y}".to_sym
    }
  end

  def overview

  end

  def view_overview
    if (Time.now - current_user.pattern_user.last_overview_look) > 24.hours
      current_user.pattern_user.update_attributes(last_overview_look: Time.now)
      @pattern_tiles = PatternTile.surrounding_tiles(current_user.pattern_user.x, current_user.pattern_user.y, 15)
    end
    render :overview
  end

  def move
    @pattern_user = current_user.pattern_user
    move_from_tile = @pattern_user.pattern_tile
    case params[:direction].to_sym
    when :north
      x = @pattern_user.x
      y = @pattern_user.y + 1
      move_to_tile = PatternTile.find_by(x: x, y: y)
      can_move = move_to_tile.south_open && move_from_tile.north_open
    when :east
      x = @pattern_user.x + 1
      y = @pattern_user.y
      move_to_tile = PatternTile.find_by(x: x, y: y)
      can_move = move_to_tile.west_open && move_from_tile.east_open
    when :south
      x = @pattern_user.x
      y = @pattern_user.y - 1
      move_to_tile = PatternTile.find_by(x: x, y: y)
      can_move = move_to_tile.north_open && move_from_tile.south_open
    when :west
      x = @pattern_user.x - 1
      y = @pattern_user.y
      move_to_tile = PatternTile.find_by(x: x, y: y)
      can_move = move_to_tile.east_open && move_from_tile.west_open
    else
      redirect_to pattern_path, alert: "Invalid direction to move: #{params[:direction]}"
      return
    end

    messages = {}
    if (x-@pattern_user.x).abs > 1 || (y-@pattern_user.y).abs > 1
    elsif !can_move
      messages[alert] = "Cannot move #{params[:direction]}"
    else
      if move_to_tile.has_obstacle
        item = Item.find_by(item_template_id: move_to_tile.obstacle_id, location: 0, user_id: current_user.id)
        if item
          new_item = Item.new(user_id: current_user.id, location: 2, item_template_id: move_to_tile.treasure_id, origin_note: 'Found in the Pattern.')
          Item.transaction do
            item.destroy
            new_item.save
            @pattern_user.update_attributes(x: x, y: y)
            move_to_tile.update_attributes(obstacle_id: nil, treasure_id: nil)  
            current_user.user_stats.update_attributes(pattern_obstacles_cleared: current_user.user_stats.pattern_obstacles_cleared + 1)
          end
          messages[:notice] = "You've defeated the obstacle, and been awarded #{new_item.item_template.name}!"
        else
          messages[:alert] = "You need #{move_to_tile.obstacle.name} to continue #{params[:direction]}"
        end
      else
        @pattern_user.update_attributes(x: x, y: y)
      end
    end

    redirect_to pattern_path, messages
  end

  def pattern_tile
    @pattern_user = current_user.pattern_user
    @x = params[:x].to_i
    @y = params[:y].to_i
    if (@x-@pattern_user.x).abs > 1 || (@y-@pattern_user.y).abs > 1
      redirect_to pattern_path
    else
      @surrounding_tiles = PatternTile.surrounding_tiles(@x,@y)
      key = "#{@pattern_user.x}-#{@pattern_user.y}".to_sym
      @surrounding_tiles[key].text_tile.gsub!(/Y/,"</font>O<font color='white'>")
      @available_tiles = Item.where(user_id: current_user.id, location: 0, item_template_id: maze_piece_ids).order('item_template_id ASC')
    end
  end

  def place_pattern_tile
    if params[:tile]
      tile = Item.find(params[:tile])
      x = params[:x].to_i
      y = params[:y].to_i
      place(tile, x, y)
    else
      redirect_to pattern_tile_path(x: params[:x], y: params[:y]), alert: 'You need to select a Maze Piece to place.'
    end
  end

private

  def maze_piece_ids
    @maze_piece_ids ||= ItemTemplate.where(category: 'Maze/Tile').collect(&:id)
  end

  def place(tile, x, y)
    nearby_tiles = PatternTile.surrounding_tiles(x, y)
    new_tile = PatternTile.new(tile: tile_tile[tile.item_template.name.to_sym], x: x, y: y)
    north_key = "#{x}-#{y+1}".to_sym
    north_clear = !nearby_tiles.has_key?(north_key) || new_tile.north_open == nearby_tiles[north_key].south_open
    east_key = "#{x+1}-#{y}".to_sym
    east_clear = !nearby_tiles.has_key?(east_key) || new_tile.east_open == nearby_tiles[east_key].west_open
    south_key = "#{x}-#{y-1}".to_sym
    south_clear = !nearby_tiles.has_key?(south_key) || new_tile.south_open == nearby_tiles[south_key].north_open
    west_key = "#{x-1}-#{y}".to_sym
    west_clear = !nearby_tiles.has_key?(west_key) || new_tile.west_open == nearby_tiles[west_key].east_open
    if north_clear && east_clear && south_clear && west_clear
      test_tile = PatternTile.find_by(x: x, y: y)
      if test_tile
        redirect_to pattern_path, alert: "Someone has already placed a tile at (#{x},#{y})."
      else
        PatternTile.transaction do
          new_tile.save
          tile.destroy
          current_user.user_stats.update_attributes(maze_pieces_placed: current_user.user_stats.maze_pieces_placed + 1)
        end
        redirect_to pattern_path, notice: "#{tile.item_template.name} placed at (#{x},#{y})"
      end
    else
      redirect_to pattern_tile_path(x: x, y: y), alert: "#{tile.item_template.name} cannot be placed at (#{x},#{y})"
    end
  end

  def tile_tile
    {
      :"Maze Piece (N)"    => '1000',
      :"Maze Piece (E)"    => '0100',
      :"Maze Piece (S)"    => '0010',
      :"Maze Piece (W)"    => '0001',
      :"Maze Piece (NE)"   => '1100',
      :"Maze Piece (NS)"   => '1010',
      :"Maze Piece (NW)"   => '1001',
      :"Maze Piece (ES)"   => '0110',
      :"Maze Piece (EW)"   => '0101',
      :"Maze Piece (SW)"   => '0011',
      :"Maze Piece (NES)"  => '1110',
      :"Maze Piece (NSW)"  => '1011',
      :"Maze Piece (NEW)"  => '1101',
      :"Maze Piece (ESW)"  => '0111',
      :"Maze Piece (NESW)" => '1111'
    }
  end

end
