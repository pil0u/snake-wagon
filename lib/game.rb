require 'gosu'
require_relative 'snake'

class Game < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Le serpent @ Le Wagon"

    @snake = Snake.new
  end

  def update
    # ...
  end

  def draw
    @snake.draw
  end
end

Game.new.show
