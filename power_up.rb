
class Power_up
  attr_accessor :stop
  def initialize image
    @has_been_eaten = false
    @insect = image
    @angle = 0.0
    @x = Random.rand(50...500)
    @y = Random.rand(30..450)
    @X_OFF_SCREEN = -10
    @Y_OFF_SCREEN = -10

  end
  # Method that randomly generates x and y values
  def get_new_location
    @x = Random.rand(50...500)
    @y = Random.rand(30..450)
  end
  # Method that places the insect object outside of viewing area until next level of play
  def eaten
      @x = @X_OFF_SCREEN
      @y = @Y_OFF_SCREEN
  end

  def get_y
   return @y
  end

  def get_x
    return @x
  end

  def draw
      @insect.draw_rot(@x, @y, 2, 0, 0.5, 0.5, 0.25, 0.25, 0xff_ffffff, mode = :default)
  end

  def move

  end
end
