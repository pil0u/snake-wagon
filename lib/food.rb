class Food
  TILE_SIZE = Config::TILE_SIZE

  def initialize(x, y)
    @x = x
    @y = y
  end

	def draw
    Gosu.draw_rect(@x, @y, TILE_SIZE, TILE_SIZE, Gosu::Color::RED)
	end
end
