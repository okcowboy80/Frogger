
class Vehicle
  attr_accessor :stop
  def initialize image, orientation
    @orient = orientation
    @vehicle_image = image
    @@speed = 2
    @DIVIDE_LINE = 210
    @angle = 0.0
    @stop = false
    get_new_y
    @near_x = [-525, -450, -375, -300, -225, -150, -75, 0]
    @far_x = [650, 725, 800, 875, 950, 1025, 1100, 1175]

    @x_farside = @far_x.sample
    @x_nearside = @near_x.sample
  end

  def get_new_y
    if @orient == "Left"
      @y = [70, 100, 135, 168, 200].sample
    else
      @y = [230, 263, 265, 310, 340].sample
    end
    return @y
  end

  def get_orient
    return @orient
  end

  def get_x_farside
   return @x_farside
  end

  def get_x_nearside
    return @x_nearside
  end

  def get_y
   return @y
  end

  def get_new_far_x
    @x_farside = @far_x.sample
  end

  def get_new_near_x
    @x_nearside = @near_x.sample
  end

  def draw
    if @orient == "Left"
      @vehicle_image.draw_rot(@x_farside, @y, 0, 0)
    else
      @vehicle_image.draw_rot(@x_nearside, @y, 0, 0)
    end
  end

  def speed vel
    @@speed += vel
  end

  def move
    while @orient == "Right" && @y <= 230
      get_new_y
    end
    if @stop == false
      if @y <= 230
        @x_farside -= @@speed
      elsif @y > 230
        @x_nearside += @@speed
      else
        if @orient == "Left"
          get_new_far_x
        else
          get_new_near_x
        end
      end
      if @x_farside <= -250
        get_new_far_x
        get_new_y
      end
      if @x_nearside > 900
        get_new_near_x
        get_new_y
      end
    end
  end
end
