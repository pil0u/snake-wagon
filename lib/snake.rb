class Snake
  TILE_SIZE = 20

  def initialize
    @x = TILE_SIZE
    @y = TILE_SIZE
  end

	def draw
		Gosu.draw_rect(@x, @y, TILE_SIZE, TILE_SIZE, Gosu::Color::WHITE)
	end
end
