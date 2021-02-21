# frozen_string_literal: true

require 'etc'

class Item
  attr_reader :path

  def initialize(path)
    @path = path
    @content = read_content
  end

  def lines_count
    @content.count("\n")
  end

  def words_count
    @content.scan(/[^[:blank:]\s]+/).size
  end

  def bytesize_count
    @content.bytesize
  end

  private

  def read_content
    @path ? File.read(@path) : $stdin.read
  end
end
