#!/bin/env ruby
# encoding: utf-8

class PatternTile < ActiveRecord::Base

  validates_presence_of :tile

  after_initialize :set_tile
  before_create :set_obstacle_and_prize

  def set_tile
    key = "#{tile}".to_sym
    @text_tile = self.class.tiles[key]
    if @text_tile.nil?
      $stderr.puts "PatternTile has no text_tile! Tile = #{tile}"
    elsif !obstacle_id.nil?
      @text_tile.gsub!(/Y/,"</font>X<font color='white'>")
    end
  end

  def text_tile
    @text_tile
  end

  def simple_tile
    PatternTile.simple_tiles[tile.to_sym]
  end

  def self.empty_tile
    self.tiles[:"0000"]
  end

  def north_open
    self.tile[0] == '1'
  end

  def east_open
    self.tile[1] == '1'
  end

  def south_open
    self.tile[2] == '1'
  end

  def west_open
    self.tile[3] == '1'
  end

  def self.surrounding_tiles(x, y, range = 2)
    tiles = self.where("x > #{x-(range+1)} AND x < #{x+(range+1)} AND y > #{y-(range+1)} AND y < #{y+(range+1)}")
    pattern_tile_hash = {}
    tiles.each do |pattern_tile|
      key = "#{pattern_tile.x}-#{pattern_tile.y}".to_sym
      pattern_tile_hash[key] = pattern_tile
    end
    pattern_tile_hash
  end

  def has_obstacle
    !obstacle_id.nil?
  end

  def obstacle
    ItemTemplate.find(self.obstacle_id)
  end


  def self.simple_tiles
    {
      :"Maze Piece (NESW)" => '╋',
      :"Maze Piece (NES)" => '┣',
      :"Maze Piece (NEW)" => '┻',
      :"Maze Piece (NE)" => '┗',
      :"Maze Piece (NSW)" => '┫',
      :"Maze Piece (NS)" => '┃',
      :"Maze Piece (NW)" => '┛',
      :"Maze Piece (N)" => '╹',
      :"Maze Piece (ESW)" => '┳',
      :"Maze Piece (ES)" => '┏',
      :"Maze Piece (EW)" => '━',
      :"Maze Piece (E)" => '╺',
      :"Maze Piece (SW)" => '┓',
      :"Maze Piece (S)" => '╻',
      :"Maze Piece (W)" => '╸',
      :"1111" => '╋',
      :"1110" => '┣',
      :"1101" => '┻',
      :"1100" => '┗',
      :"1011" => '┫',
      :"1010" => '┃',
      :"1001" => '┛',
      :"1000" => '╹',
      :"0111" => '┳',
      :"0110" => '┏',
      :"0101" => '━',
      :"0100" => '╺',
      :"0011" => '┓',
      :"0010" => '╻',
      :"0001" => '╸',
      :"0000" => '*'
    }
  end

private

  def self.tiles
    {
      :"1111" => "XX|<font color='white'>...</font>|XX<br>--'<font color='white'>...</font>'--<br><font color='white'>....Y....</font><br>--.<font color='white'>...</font>.--<br>XX|<font color='white'>...</font>|XX",
      :"1110" => "XX|<font color='white'>...</font>|XX<br>XX|<font color='white'>...</font>'--<br>XX|<font color='white'>.Y....</font><br>XX|<font color='white'>...</font>.--<br>XX|<font color='white'>...</font>|XX",
      :"1101" => "XX|<font color='white'>...</font>|XX<br>—-'<font color='white'>...</font>'--<br><font color='white'>....Y....</font><br>—--------<br>XXXXXXXXX",
      :"1100" => "XX|<font color='white'>...</font>|XX<br>XX|<font color='white'>...</font>'--<br>XX|<font color='white'>.Y....</font><br>XX'------<br>XXXXXXXXX",
      :"1011" => "XX|<font color='white'>...</font>|XX<br>—-'<font color='white'>...</font>|XX<br><font color='white'>....Y.</font>|XX<br>—-.<font color='white'>...</font>|XX<br>XX|<font color='white'>...</font>|XX",
      :"1010" => "XX|<font color='white'>...</font>|XX<br>XX|<font color='white'>...</font>|XX<br>XX|<font color='white'>.Y.</font>|XX<br>XX|<font color='white'>...</font>|XX<br>XX|<font color='white'>...</font>|XX",
      :"1001" => "XX|<font color='white'>...</font>|XX<br>—-'<font color='white'>...</font>|XX<br><font color='white'>....Y.</font>|XX<br>—-----'XX<br>XXXXXXXXX",
      :"1000" => "XX|<font color='white'>...</font>|XX<br>XX|<font color='white'>...</font>|XX<br>XX|<font color='white'>.Y.</font>|XX<br>XX'—--'XX<br>XXXXXXXXX",
      :"0111" => "XXXXXXXXX<br>---------<br><font color='white'>....Y....</font><br>—-.<font color='white'>...</font>.--<br>XX|<font color='white'>...</font>|XX",
      :"0110" => "XXXXXXXXX<br>XX.------<br>XX|<font color='white'>.Y....</font><br>XX|<font color='white'>...</font>.--<br>XX|<font color='white'>...</font>|XX",
      :"0101" => "XXXXXXXXX<br>---------<br><font color='white'>....Y....</font><br>—------—-<br>XXXXXXXXX",
      :"0100" => "XXXXXXXXX<br>XX.------<br>XX|<font color='white'>.Y....</font><br>XX'----—-<br>XXXXXXXXX",
      :"0011" => "XXXXXXXXX<br>------.XX<br><font color='white'>....Y.</font>|XX<br>—-.<font color='white'>...</font>|XX<br>XX|<font color='white'>...</font>|XX",
      :"0010" => "XXXXXXXXX<br>XX.—--.XX<br>XX|<font color='white'>.Y.</font>|XX<br>XX|<font color='white'>...</font>|XX<br>XX|<font color='white'>...</font>|XX",
      :"0001" => "XXXXXXXXX<br>------.XX<br><font color='white'>....Y.</font>|XX<br>------'XX<br>XXXXXXXXX",
      :"0000" => "XXXXXXXXX<br>XXXXXXXXX<br>XXXXXXXXX<br>XXXXXXXXX<br>XXXXXXXXX"
    }
  end

  def set_obstacle_and_prize
    maze_tiles = ItemTemplate.where(category: 'Maze/Tile').pluck(:id)
    obstacle = Item.where("location = 1 AND price > 0 AND price < 1000 AND item_template_id NOT IN (?)", maze_tiles).order('RAND()').first
    if obstacle
      self.obstacle_id = obstacle.item_template_id
    else
      results = Item.connection.execute('SELECT item_template_id, COUNT(item_template_id) FROM items GROUP BY item_template_id').to_a
      results.select! { |result| result[1] > 100 }
      self.obstacle_id = results.sample[0]
    end

    # FORMULA FOR prizes REDACTED
    self.treasure_id = prizes.sample.id
  end
  
end
