require 'gosu'
require_relative 'Player'
require_relative 'Traffic'
require_relative 'Vehicle'
require_relative 'Power_up'

class Frogger < Gosu::Window

  def initialize
    super 640, 480, :fullscreen => true
    self.caption = "Frogger"
    @width = self.width
    @height = self.height
    @is_squished = false
    @has_been_eaten = false
    @count = 0
    @SAFE_VEHICLE_DISTANCE = 35
    @CAR_WIDTH = 10
    @background_image = Gosu::Image.new("media/images/png/grass_1.png", :tileable => true)
    @road_image = Gosu::Image.new("media/images/png/road_2.gif", :tileable => true)
    @player = Player.new
    # Trees
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

    # Insect power-ups
    @power_ups = []
    @power_ups << @power_up_1 = Power_up.new(Gosu::Image.new("media/images/png/ant_brown.png"))
    @power_ups << @power_up_2 = Power_up.new(Gosu::Image.new("media/images/png/beetle_brown.png"))
    @power_ups << @power_up_3 = Power_up.new(Gosu::Image.new("media/images/png/butterfly_blue.png"))
    @power_ups << @power_up_4 = Power_up.new(Gosu::Image.new("media/images/png/butterfly_orange.png"))
    @power_ups << @power_up_5 = Power_up.new(Gosu::Image.new("media/images/png/butterfly_purple.png"))
    @power_ups << @power_up_6 = Power_up.new(Gosu::Image.new("media/images/png/butterfly_red.png"))
    @power_ups << @power_up_5 = Power_up.new(Gosu::Image.new("media/images/png/fly_blue.png"))
    @music_play = true
    @insect = @power_ups.sample
    @bug = Gosu::Sample.new("media/audio/bug.wav")
    @traffic = Gosu::Sample.new("media/audio/traffic.wav")
    @traffic.play(0.1,1, @music_play)
    @car_brakes = Gosu::Sample.new("media/audio/brakes.wav")

    @killed = Gosu::Image.from_text(self, "Game Over!", Gosu.default_font_name, 25)

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
        if Gosu.distance(@player.get_x, @player.get_y, car.get_x_farside, car.get_y) <= @SAFE_VEHICLE_DISTANCE
          @is_squished = true
          is_hit = true
          @car_brakes.play(0.2,1,false)

          return is_hit
        end
    end

    if car.get_orient == "Right"
        if Gosu.distance(@player.get_x, @player.get_y, car.get_x_nearside, car.get_y) <= @SAFE_VEHICLE_DISTANCE
          @is_squished = true
          is_hit = true
          @car_brakes.play(0.2,1,false)
          return is_hit
        end

    end
  end
  # Method that detects whether or not a car collides with another car.
  def has_car_collided? vehicle
    cnt = 0
    @cars.each do |car|
      count = 0
      @cars.each do |other_car|

        if car.get_orient == "Left" && other_car.get_orient == "Left"
          if cnt == count
            next
          else
            if Gosu.distance(car.get_x_farside, car.get_y, other_car.get_x_farside, other_car.get_y) <= @SAFE_VEHICLE_DISTANCE
              car.get_new_far_x
              car.get_new_y
            end
          end
        elsif car.get_orient == "Right" && other_car.get_orient == "Right"
          if cnt == count
            next
          else
              if Gosu.distance(other_car.get_x_nearside, other_car.get_y, car.get_x_nearside, car.get_y) <= @SAFE_VEHICLE_DISTANCE
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
  # Method that increases the level each time the player collects the insect and reaches the top
  def level_up
      if @has_been_eaten
        if @has_been_eaten && @player.check_level == 1
          @cars[0].speed 1
          @insect.get_new_location
          @has_been_eaten = false
        end
      end
  end
  # method that increases the player's speed once an insect has been eaten
  def has_powered_up?
    if Gosu.distance(@player.get_x, @player.get_y, @insect.get_x, @insect.get_y)< 35 && @has_been_eaten == false
      @player.speed 1
      @bug.play(1,1,false)

      @insect.eaten
      @has_been_eaten = true
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
    @background_image.draw(@width*0.35,0,0)
    @background_image.draw(0,@height*0.47,0)
    @background_image.draw(@width*0.35,@height*0.47,0)
    @background_image.draw(@width*0.7,0,0)
    @background_image.draw(0,@height*0.938,0)
    @background_image.draw(@width*0.7,@height*0.938,0)
    @background_image.draw(@width*0.7,@height*0.47,0)
    @background_image.draw(@width*0.35,@height*0.938,0)
    @road_image.draw(0, 30, 0)
    @road_image.draw(470, 30, 0)

    @tree_1.draw(-10, @height*0.47, 1)
    @tree_2.draw(@width*0.7032, @height*0.521, 1)
    @tree_6.draw_rot(@width*0.18, -15, 1, 0, 0.5, 0.5, 0.5, 0.5, 0xff_ffffff, mode = :default)
    @tree_6.draw_rot(@width*0.65, -15, 1, 0, 0.5, 0.5, 0.5, 0.5, 0xff_ffffff, mode = :default)
    @tree_5.draw_rot(@width*0.43, -50, 1, 0, 0.5, 0.5, 0.5, 0.5, 0xff_ffffff, mode = :default)

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
    if @is_squished
      squished
    end
  end

  # Method that detects if the escape key was pressed to exit the game.
  def button_down(id)
    if id == Gosu::KB_ESCAPE
      @music_play = false
      close
    else
      super
    end
  end
end
  # Method that sets the player back to original starting place.
  def squished
    @player.set_x 300
    @player.set_y 375
    @is_squished = false
  end

Frogger.new.show
