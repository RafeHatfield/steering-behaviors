##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'startup_state'
require 'wander_state'
require 'seek_state'
require 'flee_state'
require 'pursue_state'
require 'arrive_state'
require 'evade_state'
require 'align_state'
require 'match_state'
require 'broadside_state'
require 'orthogonal_state'
require 'steering_behaviors'

class Game < StateBasedGame
  def initialize(name)
    super(name)
  end

  def run
    $logger.debug "Game::run()"
    container = AppGameContainer.new(self)
    container.set_display_mode(800, 800, false)

    # Fix for super high frame rates / limit updates compared to renders:
    # A minimum interval (in ms) that has to pass since the last update() call
    # before update() is called again.
    container.setMinimumLogicUpdateInterval(20)

    # Fix for really slow frame rates / let updates 'catch up' to renders:
    # If the interval since the last update() call exceeds this value, then Slick
    # divides the accrued time by this value and runs update() that many times
    container.setMaximumLogicUpdateInterval(50)

    container.start
  end

  def initStatesList(container)
    $logger.debug "Game::initStatesList()"

    # The order you add them is important; starting state must be first.
    addState StartupState.new
    addState WanderState.new
    addState SeekState.new
    addState FleeState.new
    addState PursueState.new
    addState ArriveState.new
    addState EvadeState.new
    addState AlignState.new
    addState MatchState.new
    addState BroadsideState.new
    addState OrthogonalState.new
  end
end

