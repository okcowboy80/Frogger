
class Player
  attr_accessor :stop
  def initialize
    @level = 1
    @stop = false
    @@speed = 5
    @frog_front_idle = Gosu::Image.new("media/images/png/front.png")
    @frog_front_jump = Gosu::Image.new("media/images/png/front_jump.png")
    @frog_dead_front = Gosu::Image.new("media/images/png/flat_front.png")
    @frog_back_idle = Gosu::Image.new("media/images/png/back.png")
    @frog_back_jump = Gosu::Image.new("media/images/png/back_jump.png")

    @frog_left_idle_1 = Gosu::Image.new("media/images/png/left_1.png")
    @frog_left_idle_2 = Gosu::Image.new("media/images/png/left_2.png")
    @frog_left_jump = Gosu::Image.new("media/images/png/left_jump.png")

    @frog_right_idle_1 = Gosu::Image.new("media/images/png/right_1.png")
    @frog_right_idle_2 = Gosu::Image.new("media/images/png/right_2.png")
    @frog_right_jump = Gosu::Image.new("media/images/png/right_jump.png")
    @jump = Gosu::Sample.new("media/audio/jump.wav")

    @frog = @frog_back_idle
    @x = @y = @angle = 0.0
    @score = 1

    @X_RESTART = 350
    @Y_RESTART = 400

    @X_BORDER_LEFT = 15
    @X_BORDER_RIGHT = 620

    @Y_BORDER_TOP = 15
    @Y_BORDER_BOTTOM = 460

  end
  # Method that checks to see if player is able to level up if so increments the level variable and resets the player to the bottom of the screen
  def check_level
    if @y <= @Y_BORDER_TOP
      @level += 1
      @x = @X_RESTART
      @y = @Y_RESTART
      return 1
    else
      return 0
    end
  end
  # Method that increases the speed by the number passed in to the method
  def speed vel
    @@speed += vel
  end

  def get_speed
    return @@speed
  end

  def get_level
    return @level
  end

  def move_left
    @frog = [@frog_left_idle_1, @frog_left_jump, @frog_left_idle_2].sample
    if @x >= @X_BORDER_LEFT
      @x -= @@speed
      @jump.play(0.5,1,false)
    end

    @frog
  end

  def move_right
    @frog = [@frog_right_idle_1, @frog_right_jump, @frog_right_idle_2].sample
    if @x <= @X_BORDER_RIGHT
      @x += @@speed
      @jump.play(0.5,1,false)
    end

    @frog

  end
  def get_x
   @x
  end

  def get_y
   @y
  end

  def set_x x
    @x = x
  end

  def set_y y
    @y = y
  end

  def move_up
    @frog = [@frog_back_idle, @frog_back_jump].sample
    if @y > @Y_BORDER_TOP
      @y -= @@speed
      @jump.play(0.5,1,false)
    end

    @frog
  end

  def move_down
    @frog = [@frog_front_idle,@frog_front_jump].sample
    if @y < @Y_BORDER_BOTTOM
      @y += @@speed
      @jump.play(0.5,1,false)
    end

    @frog
  end

  def warp x, y
    @x, @y = x, y
  end

  def draw
    if @stop == false
      @frog.draw_rot(@x, @y, 0, @angle)
    end
  end
end
