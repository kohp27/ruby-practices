# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(score_str)
    @shots = parse_score_str(score_str)
    @frames = create_frames(@shots)
  end

  def score
    fallen_pins_sum = @shots.sum(&:fallen_pins)

    shot_index = 0
    bonus_excluding_last_frame = @frames[0...-1].sum do |frame|
      shot_index += frame.shots.size
      add_frames_num =
        if frame.strike? then 2
        elsif frame.spare? then 1
        else 0
        end
      @shots[shot_index, add_frames_num].sum(&:fallen_pins)
    end

    fallen_pins_sum + bonus_excluding_last_frame
  end

  private

  def parse_score_str(score_str)
    score_str.chars.map { |score_char| Shot.new(score_char) }
  end

  def create_frames(shots)
    shots.each_with_object([]).with_index do |(shot, frames), i|
      if frames.size < 9
        before_frame = frames.last
        should_create_new_frame = before_frame.nil? || before_frame.strike? || before_frame.shots.size == 2

        frames << Frame.new([]) if should_create_new_frame
        frames.last.shots << shot
      else
        frames << Frame.new(shots[i..-1])
        break frames
      end
    end
  end
end
