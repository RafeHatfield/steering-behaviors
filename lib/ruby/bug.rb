require 'steering-behaviors/steering_behaviors'

class Bug
  include SteeringBehaviors

  attr_reader :course, :speed, :mass, :maneuverability
  attr_reader :heading_vec, :velocity_vec, :position_vec

  attr_accessor :min_speed, :max_speed, :max_turn
  attr_accessor :steering_target

  # World units!
  # Currently meters and meters-per-second
  #
  # * *Args*    :
  #   - +x+ -> starting X pos
  #   - +y+ -> starting Y pos
  #   - +course+ -> course in true degrees (0 is north)
  #   - +speed+ -> speed
  #   - +mass+ -> mass of the thing (more mass means slower acceleration)
  #   - +maneuverability+ -> maneuverability of the thing (more means faster turning)
  #   - +max_turn+ -> max turn rate in rads per sec
  #   - +min_speed+ -> min speed
  #   - +max_speed+ -> max speed
  #
  def initialize(x, y, course, speed, mass, maneuverability, max_turn, min_speed, max_speed)
    super()

    @position_vec = Vector.new(x, y) # A non-normalized vector holding X,Y position

    @course          = course
    @speed           = speed
    @mass            = mass
    @maneuverability = maneuverability
    @max_turn        = max_turn
    @min_speed       = min_speed
    @max_speed       = max_speed

    @steering_target   = Vector.new(0, 1.0) # relative to me; i.e. straight ahead

    # We could, in theory, handle 'pointing in one direction while moving in another.'
    # (Think of the spaceship in _Asteroids_.) In this simulation we don't bother,
    # but we support such capability.
    @velocity_vec = Vector.new # A non-normalized vector implying direction AND speed.
    @heading_vec  = Vector.new # A normalized vector for pure heading information

    calculate_vectors
  end

  def velocity_vec=(new_vec)
    @velocity_vec = new_vec
    @velocity_vec.truncate!(@max_speed)

    @course      = @velocity_vec.compass_bearing
    @heading_vec = @velocity_vec.normalize

    if @velocity_vec.length < @min_speed
      @speed = @min_speed
      calculate_vectors
    else
      @speed = @velocity_vec.length
    end
  end

  def course=(degrees)
    @course = degrees
    calculate_vectors
  end

  def speed=(mps)
    @speed = mps
    calculate_vectors
  end

  def course_in_degs
    sprintf("%03d", course.round)
  end

  def move(delta)
    @position_vec += @velocity_vec * delta
  end

  private

  def calculate_vectors
    @velocity_vec.x = @speed * Math.sin(Vector.deg2rad(@course))
    @velocity_vec.y = @speed * Math.cos(Vector.deg2rad(@course))

    @heading_vec = @velocity_vec.normalize
  end
end
