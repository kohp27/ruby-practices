# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative 'item_list'

class WcTest < Minitest::Test
  SINGLE_FILE = %w[item.rb].freeze
  MULTI_FILES = %w[item.rb item_list.rb wc.rb].freeze
  STDIN_CONTENT = <<~INPUT
    test test
    abcdefg
  INPUT

  def setup
    $stdout = StringIO.new
  end

  def test_single
    expected_result = <<-RESULT
      30      40     403 item.rb
    RESULT
    ItemList.new(SINGLE_FILE, false).display
    assert_equal expected_result, $stdout.string
  end

  def test_multi
    expected_result = <<-RESULT
      30      40     403 item.rb
      46     109    1087 item_list.rb
      18      36     352 wc.rb
      94     185    1842 total
    RESULT
    ItemList.new(MULTI_FILES, false).display
    assert_equal expected_result, $stdout.string
  end

  def test_stdin
    expected_result = <<-RESULT
       2       3      18
    RESULT
    $stdin = StringIO.new(STDIN_CONTENT)
    ItemList.new([], false).display
    assert_equal expected_result, $stdout.string
  end

  def test_single_with_l_option
    expected_result = <<-RESULT
      30 item.rb
    RESULT
    ItemList.new(SINGLE_FILE, true).display
    assert_equal expected_result, $stdout.string
  end

  def test_multi_with_l_option
    expected_result = <<-RESULT
      30 item.rb
      46 item_list.rb
      18 wc.rb
      94 total
    RESULT
    ItemList.new(MULTI_FILES, true).display
    assert_equal expected_result, $stdout.string
  end

  def test_stdin_with_l_option
    expected_result = <<-RESULT
       2
    RESULT
    $stdin = StringIO.new(STDIN_CONTENT)
    ItemList.new([], true).display
    assert_equal expected_result, $stdout.string
  end
end
