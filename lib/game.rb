require 'gosu'
require_relative '../config'
require_relative 'food'
require_relative 'snake'

class Game < Gosu::Window
  def initialize
    super Config::WINDOW_SIZE, Config::WINDOW_SIZE
    self.caption = "Le serpent @ Le Wagon"
    @background_image = Gosu::Image.new('./media/background.jpg', tileable: true)
    @font = Gosu::Font.new(24)

    initialize_highscore
    reset_game_states
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

      if @score > @highscore
        @highscore = @score
        update_highscore(@highscore)
      end

      reset_game_states
    end

    if @food.eaten_by?(@snake)
      @snake.expand

      @food.play_sound
      @food = Food.popup

      accelerate
      @score += 1
    end
  end

  def draw
    @background_image.draw(0, 0, 0)

    @snake.draw
    @food.draw

    @font.draw_text("Score: #{@score} / High score: #{@highscore}", 10, 10, 0, 1, 1, color=Gosu::Color::YELLOW)
  end

  private

  def accelerate
    @refresh_rate *= (1 - Config::ACCELERATION_RATE)
  end

  def button_up(id)
    id == Gosu::KB_ESCAPE ? close : super
  end

  def initialize_highscore
    if File.exist? Config::HIGH_SCORE_PATH
      file = File.open(Config::HIGH_SCORE_PATH)
      @highscore = file.readlines.last.split(' --- ').last.to_i
      file.close
    else
      @highscore = 0
      update_highscore(@highscore)
    end
  end

  def update_highscore(score)
    file = File.new(Config::HIGH_SCORE_PATH, "a")
    file.puts("#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} --- #{score}")
    file.close
  end

  def reset_game_states
    @game_speed = Config::INITIAL_GAME_SPEED
    @refresh_rate = 1.0 / @game_speed
    @last_timestamp = Time.now

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
