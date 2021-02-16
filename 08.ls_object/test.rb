# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative 'item_list'

class LsTest < Minitest::Test
  DIR_PATH = 'fixture'
  FILE_PATH = 'fixture/dammy'

  def setup
    $stdout = StringIO.new
  end

  def test_no_option_width80
    expected_result = <<~RESULT
      dammy		dammy_large	everyone_group	permissions_777
      dammy_dir	dammy_link	past		root_user
    RESULT
    ItemList.new(dotfiles: false, long: false, reverse: false, path: DIR_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_no_option_width30
    expected_result = <<~RESULT
      dammy
      dammy_dir
      dammy_large
      dammy_link
      everyone_group
      past
      permissions_777
      root_user
    RESULT
    ItemList.new(dotfiles: false, long: false, reverse: false, path: DIR_PATH).display(30)
    assert_equal expected_result, $stdout.string
  end

  def test_a_option_width80
    expected_result = <<~RESULT
      .		dammy		dammy_link	permissions_777
      ..		dammy_dir	everyone_group	root_user
      .dotfile	dammy_large	past
    RESULT
    ItemList.new(dotfiles: true, long: false, reverse: false, path: DIR_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_r_option_width80
    expected_result = <<~RESULT
      root_user	past		dammy_link	dammy_dir
      permissions_777	everyone_group	dammy_large	dammy
    RESULT
    ItemList.new(dotfiles: false, long: false, reverse: true, path: DIR_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_ar_option_width80
    expected_result = <<~RESULT
      root_user	everyone_group	dammy_dir	..
      permissions_777	dammy_link	dammy		.
      past		dammy_large	.dotfile
    RESULT
    ItemList.new(dotfiles: true, long: false, reverse: true, path: DIR_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_l_option
    expected_result = <<~RESULT
      total 256
      -rw-r--r--  1 k     staff          6  2 16 21:55 dammy
      drwxr-xr-x  3 k     staff         96  2 16 21:55 dammy_dir
      -rw-r--r--  1 k     staff     125952  2 16 21:55 dammy_large
      lrwxr-xr-x  1 k     staff          5  2 16 21:55 dammy_link -> dammy
      -rw-r--r--  1 k     everyone       0  2 16 21:55 everyone_group
      -rw-r--r--  1 k     staff          0  1  1  2020 past
      -rwxrwxrwx  1 k     staff          0  2 16 21:55 permissions_777
      -rw-r--r--  1 root  staff          0  2 16 21:55 root_user
    RESULT
    ItemList.new(dotfiles: false, long: true, reverse: false, path: DIR_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_al_option
    expected_result = <<~RESULT
      total 256
      drwxr-xr-x  11 k     staff        352  2 16 21:55 .
      drwxr-xr-x   9 k     staff        288  2 16 22:07 ..
      -rw-r--r--   1 k     staff          0  2 16 21:55 .dotfile
      -rw-r--r--   1 k     staff          6  2 16 21:55 dammy
      drwxr-xr-x   3 k     staff         96  2 16 21:55 dammy_dir
      -rw-r--r--   1 k     staff     125952  2 16 21:55 dammy_large
      lrwxr-xr-x   1 k     staff          5  2 16 21:55 dammy_link -> dammy
      -rw-r--r--   1 k     everyone       0  2 16 21:55 everyone_group
      -rw-r--r--   1 k     staff          0  1  1  2020 past
      -rwxrwxrwx   1 k     staff          0  2 16 21:55 permissions_777
      -rw-r--r--   1 root  staff          0  2 16 21:55 root_user
    RESULT
    ItemList.new(dotfiles: true, long: true, reverse: false, path: DIR_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_lr_option
    expected_result = <<~RESULT
      total 256
      -rw-r--r--  1 root  staff          0  2 16 21:55 root_user
      -rwxrwxrwx  1 k     staff          0  2 16 21:55 permissions_777
      -rw-r--r--  1 k     staff          0  1  1  2020 past
      -rw-r--r--  1 k     everyone       0  2 16 21:55 everyone_group
      lrwxr-xr-x  1 k     staff          5  2 16 21:55 dammy_link -> dammy
      -rw-r--r--  1 k     staff     125952  2 16 21:55 dammy_large
      drwxr-xr-x  3 k     staff         96  2 16 21:55 dammy_dir
      -rw-r--r--  1 k     staff          6  2 16 21:55 dammy
    RESULT
    ItemList.new(dotfiles: false, long: true, reverse: true, path: DIR_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_alr_option
    expected_result = <<~RESULT
      total 256
      -rw-r--r--   1 root  staff          0  2 16 21:55 root_user
      -rwxrwxrwx   1 k     staff          0  2 16 21:55 permissions_777
      -rw-r--r--   1 k     staff          0  1  1  2020 past
      -rw-r--r--   1 k     everyone       0  2 16 21:55 everyone_group
      lrwxr-xr-x   1 k     staff          5  2 16 21:55 dammy_link -> dammy
      -rw-r--r--   1 k     staff     125952  2 16 21:55 dammy_large
      drwxr-xr-x   3 k     staff         96  2 16 21:55 dammy_dir
      -rw-r--r--   1 k     staff          6  2 16 21:55 dammy
      -rw-r--r--   1 k     staff          0  2 16 21:55 .dotfile
      drwxr-xr-x   9 k     staff        288  2 16 22:07 ..
      drwxr-xr-x  11 k     staff        352  2 16 21:55 .
    RESULT
    ItemList.new(dotfiles: true, long: true, reverse: true, path: DIR_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_no_option_file
    expected_result = <<~RESULT
      fixture/dammy
    RESULT
    ItemList.new(dotfiles: false, long: false, reverse: false, path: FILE_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end

  def test_l_option_file
    expected_result = <<~RESULT
      -rw-r--r--  1 k  staff  6  2 16 21:55 fixture/dammy
    RESULT
    ItemList.new(dotfiles: false, long: true, reverse: false, path: FILE_PATH).display(80)
    assert_equal expected_result, $stdout.string
  end
end
