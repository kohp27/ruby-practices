# frozen_string_literal: true

class Shot
  attr_accessor :fallen_pins

  def initialize(score_char)
    @fallen_pins = char_to_fallen_pins(score_char)
  end

  private

  def char_to_fallen_pins(score_char)
    score_char == 'X' ? 10 : score_char.to_i
  end
end
