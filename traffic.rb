
class Traffic
  def initialize

    @traffic_left_facing = [Gosu::Image.new("media/images/png/car_orange_left_facing.png"),
                            Gosu::Image.new("media/images/png/car_red_left_facing.png"),
                            Gosu::Image.new("media/images/png/car_yellow_left_facing.png"),
                            Gosu::Image.new("media/images/png/semi_left_facing.png"),
                            Gosu::Image.new("media/images/png/semi_loaded_left_facing.png")

                           ]
    @traffic_right_facing = [Gosu::Image.new("media/images/png/car_orange_right_facing.png"),
                             Gosu::Image.new("media/images/png/car_red_right_facing.png"),
                             Gosu::Image.new("media/images/png/car_yellow_right_facing.png"),
                             Gosu::Image.new("media/images/png/sports_car_red_right_facing.png"),
                             Gosu::Image.new("media/images/png/semi_right_facing.png")
                            ]
    @x = @y = @angle = 0.0
    @car_y = [70, 100, 130, 160, 190, 220, 250, 280, 310, 340]
    @left_car = Gosu::Image.new("media/images/png/car_orange_left_facing.png")
    @right_car = Gosu::Image.new("media/images/png/car_orange_right_facing.png")
    @cars = []
  end

  def move_left

  end

  def move_right

  end

  def pick_left_car
    @left_car = @traffic_left_facing.sample
    @traffic_left_facing.each do |car|

    end
  end
  def pick_right_car
    @right_car = @traffic_right_facing.sample
  end

  def pick_y
    @car_y.sample
  end

  def move
    @x %= 640
    @y %= 400
  end

  def warp x, y
    @x, @y = x, y
  end

  def draw
    @left_car.draw_rot(220, 100, 1, 0)
    @right_car.draw_rot(100, 235, 1, 0)
  end
end
