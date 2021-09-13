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
    @background_image = Gosu::Image.new('./media/background.jpg', tileable: true)
    @font = Gosu::Font.new(24)

    # Force 1 mise à jour toutes les 0.1 secondes (au lieu de 0.016)
    @refresh_rate = 0.1
    @last_timestamp = Time.now

    @snake = Snake.new
    @food = Food.popup
    @score = 0
  end

  def update
    return if (Time.now - @last_timestamp) < @refresh_rate

    update_snake_direction
    @snake.move
    @last_timestamp = Time.now

    if @snake.dead?
      sound = @snake.play_dead_sound
      sleep(3)
      sound.stop

      reset_game
    end

    if @food.eaten_by?(@snake)
      @snake.expand
      accelerate
      @score += 1

      @food.play_sound
      @food = Food.popup
    end
  end

  def draw
    @background_image.draw(0, 0, 0)

    @snake.draw
    @food.draw

    @font.draw_text("Score: #{@score}", 10, 10, 0, 1, 1, color=Gosu::Color::YELLOW)
  end

  private

  def accelerate
    @refresh_rate = @refresh_rate * (1 - Config::ACCELERATION_RATE)
  end

  def button_up(id)
    id == Gosu::KB_ESCAPE ? close : super
  end

  def reset_game
    @refresh_rate = 0.1

    @snake = Snake.new
    @food = Food.popup
    @score = 0
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
