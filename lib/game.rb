require 'gosu'
require_relative '../config'
require_relative 'snake'

class Game < Gosu::Window
  WINDOW_SIZE = Config::WINDOW_SIZE

  def initialize
    super WINDOW_SIZE, WINDOW_SIZE
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
