require 'gosu'
require_relative '../config'
require_relative 'food'
require_relative 'snake'

class Game < Gosu::Window
  WINDOW_SIZE = Config::WINDOW_SIZE
  TILE_SIZE = Config::TILE_SIZE

  def initialize
    super WINDOW_SIZE, WINDOW_SIZE
    self.caption = "Le serpent @ Le Wagon"

    # Force 1 mise à jour toutes les 0.1 secondes (au lieu de 0.016)
    @refresh_rate = 0.1
    @last_timestamp = Time.now

    @snake = Snake.new
    @food = Food.popup
  end

  def update
    return if (Time.now - @last_timestamp) < @refresh_rate

    update_snake_direction
    @snake.move
    @last_timestamp = Time.now

    if @food.eaten_by?(@snake)
      @snake.expand
      accelerate
      # Mon score augmente
      # ...
      @food = Food.popup
    end
  end

  def draw
    @snake.draw
    @food.draw
  end

  private

  def accelerate
    @refresh_rate = @refresh_rate * (1 - Config::ACCELERATION_RATE)
  end

  # D'abord juste les touches, ensuite la contrainte de direction
  def update_snake_direction
    if Gosu.button_down?(Gosu::KB_RIGHT) && @snake.direction != "left"
      @snake.direction = "right"
    elsif Gosu.button_down?(Gosu::KB_DOWN) && @snake.direction != "up"
      @snake.direction = "down"
    elsif Gosu.button_down?(Gosu::KB_LEFT) && @snake.direction != "right"
      @snake.direction = "left"
    elsif Gosu.button_down?(Gosu::KB_UP) && @snake.direction != "down"
      @snake.direction = "up"
    end
  end
end

Game.new.show
