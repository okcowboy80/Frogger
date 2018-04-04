require 'gosu'
require_relative 'Player'
require_relative 'Traffic'
require_relative 'Vehicle'
require_relative 'Power_up'

class Frogger < Gosu::Window

  def initialize
    super 640, 480, :fullscreen => true
    self.caption = "Frogger"
    @has_been_eaten = false
    @count = 0
    @CAR_LENGTH = 25
    @CAR_WIDTH = 10
    @background_image = Gosu::Image.new("media/images/png/grass_1.png", :tileable => true)
    @road_image = Gosu::Image.new("media/images/png/road_2.gif", :tileable => true)
    @player = Player.new

    @tree_1 = Gosu::Image.new("media/images/png/tree_orange.png", :tileable => true)
    @tree_2 = Gosu::Image.new("media/images/png/tree_yellow.png", :tileable => true)
    @tree_3 = Gosu::Image.new("media/images/png/tree_green_1.png", :tileable => true)
    @tree_4 = Gosu::Image.new("media/images/png/tree_green_2.png", :tileable => true)
    @tree_5 = Gosu::Image.new("media/images/png/tree_green_3.png", :tileable => true)
    @tree_6 = Gosu::Image.new("media/images/png/tree_green_4.png", :tileable => true)

    @cars = []
    # LEFT FACING CARS
    @cars << @vehicle_left_1 = Vehicle.new(Gosu::Image.new("media/images/png/car_orange_left_facing.png"),"Left")
    @cars << @vehicle_left_2 = Vehicle.new(Gosu::Image.new("media/images/png/car_red_left_facing.png"),"Left")
    @cars << @vehicle_left_3 = Vehicle.new(Gosu::Image.new("media/images/png/car_yellow_left_facing.png"),"Left")
    @cars << @vehicle_left_4 = Vehicle.new(Gosu::Image.new("media/images/png/semi_left_facing.png"),"Left")
    # RIGHT FACING CARS
    @cars << @vehicle_right_5 = Vehicle.new(Gosu::Image.new("media/images/png/car_orange_right_facing.png"), "Right")
    @cars << @vehicle_right_6 = Vehicle.new(Gosu::Image.new("media/images/png/car_red_right_facing.png"), "Right")
    @cars << @vehicle_right_7 = Vehicle.new(Gosu::Image.new("media/images/png/car_yellow_right_facing.png"), "Right")
    @cars << @vehicle_right_8 = Vehicle.new(Gosu::Image.new("media/images/png/semi_right_facing.png"), "Right")
    @cars << @vehicle_right_9 = Vehicle.new(Gosu::Image.new("media/images/png/sports_car_red_right_facing.png"), "Right")
    @player.warp(320, 385)
    @hit = false

    @power_ups = []
    @power_ups << @power_up_1 = Power_up.new(Gosu::Image.new("media/images/png/ant_brown.png"))
    @power_ups << @power_up_2 = Power_up.new(Gosu::Image.new("media/images/png/beetle_brown.png"))
    @power_ups << @power_up_3 = Power_up.new(Gosu::Image.new("media/images/png/butterfly_blue.png"))
    @power_ups << @power_up_4 = Power_up.new(Gosu::Image.new("media/images/png/butterfly_orange.png"))
    @power_ups << @power_up_5 = Power_up.new(Gosu::Image.new("media/images/png/butterfly_purple.png"))
    @power_ups << @power_up_6 = Power_up.new(Gosu::Image.new("media/images/png/butterfly_red.png"))
    @power_ups << @power_up_5 = Power_up.new(Gosu::Image.new("media/images/png/fly_blue.png"))

    @insect = @power_ups.sample
    @bug = Gosu::Sample.new("media/audio/bug.wav")
  end

  # Method that detects if a button was pressed then released.
  def button_up(id)
    if id==Gosu::KB_LEFT
      @player.move_left
    end

    if id==Gosu::KB_RIGHT
      @player.move_right
    end

    if id==Gosu::KB_UP
      @player.move_up
    end

    if id==Gosu::KB_DOWN
      @player.move_down
    end
  end

  # Method that detects whether or not a car hits the player.
  def player_collision_detect car
    is_hit = false


    if car.get_orient == "Left"
      #if ((x+25) >= car_far_x && (x+25) <= car_far_x + 25)
        #if( y >= car_y && y < car_y + 25 || y + 15 > car_y && y + 15 < car_y + 20 )
        if Gosu.distance(@player.get_x, @player.get_y, car.get_x_farside, car.get_y) <= 25
          is_hit = true
          return is_hit
        end

    end

    if car.get_orient == "Right"
      #if ((x) >= car_near_x && (x) <= car_near_x + 25)
        if Gosu.distance(@player.get_x, @player.get_y, car.get_x_farside, car.get_y) <= 25
          is_hit = true
          return is_hit
        end
      end
    end
  end

  def has_car_collided? vehicle
    cnt = 0
    @cars.each do |car|

      count = 0
      @cars.each do |other_car|

        if car.get_orient == "Left" && other_car.get_orient == "Left"
          if cnt == count
            next

          else
            if Gosu.distance(car.get_x_farside, car.get_y, other_car.get_x_farside, other_car.get_y) <= 35
              #if Gosu.distance(x_value, y_value, x_value, y_value)
              car.get_new_far_x
              car.get_new_y
            end
          end
        elsif car.get_orient == "Right" && other_car.get_orient == "Right"
          if cnt == count
            next
          else
              if Gosu.distance(other_car.get_x_nearside, other_car.get_y, car.get_x_nearside, car.get_y) <= 35
                car.get_new_near_x
                car.get_new_y
              end
          end
        end
        count += 1
      end
      cnt += 1
    end
  end

  def level_up
      if @has_been_eaten
        if @has_been_eaten && @player.check_level == 1
          @cars[0].speed 1
          @insect.get_new_location
          #puts "I'm being changed to false from #{@has_been_eaten}!"
          @has_been_eaten = false
        end
      end
  end

  def has_powered_up?
    #puts "The insect eaten is: #{@has_been_eaten}"
    if Gosu.distance(@player.get_x, @player.get_y, @insect.get_x, @insect.get_y)< 35 && @has_been_eaten == false
      @player.speed 1
      @bug.play
      #puts "Player's speed has changed to: #{@player.get_speed}"
      @insect.eaten
      @has_been_eaten = true
      #puts "The insect eaten is: #{@has_been_eaten}"
    end
  end
  # Method that updates 60 frames a second and moves the cars if a collision is not detected.
  def update
    @cars.each do |car|
      unless player_collision_detect car
        car.move
      end
    end
    level_up
    has_powered_up?
  end

  # Method that updates 60 frames a second and draws the images to the screen.
  def draw
    @background_image.draw(0,0,0)
    @background_image.draw(225,0,0)
    @background_image.draw(0,225,0)
    @background_image.draw(225,225,0)
    @background_image.draw(450,0,0)
    @background_image.draw(0,450,0)
    @background_image.draw(450,450,0)
    @background_image.draw(450,225,0)
    @background_image.draw(225,450,0)
    @road_image.draw(0, 30, 0)
    @road_image.draw(475, 30, 0)
    @tree_1.draw(100, 500, 0)
    @player.draw
    @level_text = Gosu::Image.from_text(self, "Level:  #{@player.get_level} ", Gosu.default_font_name, 25)
    @level_text.draw(475, 5, 0)
    #@mouse_text = Gosu::Image.from_text(self, "X: #{@player.get_x} Y: #{@player.get_y}", Gosu.default_font_name, 25)
    #@mouse_text.draw(0,0,0)
    @title_text = Gosu::Image.from_text(self, "Frogger", Gosu.default_font_name, 25)
    @title_text.draw(0,0,0)

    @cars.each do |car|
      has_car_collided? car
      car.draw
    end
    if !@has_been_eaten
      @insect.draw
    end
  end

  # Method that detects if the escape key was pressed to exit the game.
  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

Frogger.new.show
