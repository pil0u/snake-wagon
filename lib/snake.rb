class Snake
  attr_accessor :direction

  TILE_SIZE = Config::TILE_SIZE

  def initialize
    @x = TILE_SIZE
    @y = TILE_SIZE

    @direction = "right"
  end

  def move
    case @direction
      when "right" then @x += TILE_SIZE
      when "down" then @y += TILE_SIZE
      when "left" then @x -= TILE_SIZE
      when "up" then @y -= TILE_SIZE
    end
  end

	def draw
    Gosu.draw_rect(@x, @y, TILE_SIZE, TILE_SIZE, Gosu::Color::WHITE)
	end
end
