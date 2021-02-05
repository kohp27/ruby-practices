# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'game'

class BowlingTest < Minitest::Test
  def test_example1
    assert_equal 139, Game.new('6390038273X9180X645').score
  end

  def test_example2
    assert_equal 164, Game.new('6390038273X9180XXXX').score
  end

  def test_example3
    assert_equal 107, Game.new('0X150000XXX518104').score
  end

  def test_example4
    assert_equal 134, Game.new('6390038273X9180XX00').score
  end

  def test_perfect
    assert_equal 300, Game.new('XXXXXXXXXXXX').score
  end

  def test_zero
    assert_equal 0, Game.new('00000000000000000000').score
  end
end
