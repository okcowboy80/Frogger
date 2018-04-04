
class Power_up
  attr_accessor :stop
  def initialize image
    @has_been_eaten = false
    @insect = image
    @angle = 0.0
    @x = Random.rand(100...450)
    @y = Random.rand(100..450)
  end

  def get_new_location
    @x = Random.rand(100...450)
    @y = Random.rand(100..450)
  end

  def eaten
      @x = -10
      @y = -10
  end

  def get_y
   return @y
  end

  def get_x
    return @x
  end

  def draw
      @insect.draw_rot(@x, @y, 0, 0, 0.5, 0.5, 0.25, 0.25, 0xff_ffffff, mode = :default)
  end

  def move

  end
end
