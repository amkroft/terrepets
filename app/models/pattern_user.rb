class PatternUser < ActiveRecord::Base
  belongs_to :user

  before_create :set_data

  def surrounding_tiles
    PatternTile.surrounding_tiles(self.x,self.y)
  end

  def pattern_tile
    PatternTile.find_by(x: self.x, y: self.y)
  end

private

  def set_data
    last_overview_look = Time.now
  end

end
