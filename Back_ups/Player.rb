require 'Gosu'
require 'gosu'
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

    @croaking = Gosu::Sample.new("media/audio/croaking.mp3")
    @jump = Gosu::Sample.new("media/audio/jump.mp3")
    @frog_croak = Gosu::Sample.new("media/audio/frog-croak.mp3")
    @peppers = Gosu::Sample.new("media/audio/peeper-frogs.mp3")

    @frog = @frog_back_idle
    @x = @y = @angle = 0.0
    @score = 1

  end

  def check_level
    if @y <= 40
      @level += 1
      @y = 400
      return 1
    else
      return 0
    end
  end

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
    if @x >= 15
      @x -= @@speed
      @jump.play
    end
    #sleep @sleep
    @frog
  end

  def move_right
    @frog = [@frog_right_idle_1, @frog_right_jump, @frog_right_idle_2].sample
    if @x <= 620
      @x += @@speed
    end
    #sleep @sleep
    @frog

  end
  def get_x
   @x
  end

  def get_y
   @y
  end

  def move_up
    @frog = [@frog_back_idle, @frog_back_jump].sample
    if @y > 15
      @y -= @@speed
    end
    #sleep @sleep
    @frog
  end

  def move_down
    @frog = [@frog_front_idle,@frog_front_jump].sample
    if @y < 460
      @y += @@speed
    end
    #sleep @sleep
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
