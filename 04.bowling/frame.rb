# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def strike?
    @shots.first.fallen_pins == 10
  end

  def spare?
    !strike? && @shots.first(2).sum(&:fallen_pins) == 10
  end
end
