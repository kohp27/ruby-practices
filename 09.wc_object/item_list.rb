# frozen_string_literal: true

require 'etc'
require_relative 'item'

class ItemList
  def initialize(paths, lines_count_only)
    @properties = lines_count_only ? %i[lines_count] : %i[lines_count words_count bytesize_count]

    @item_list =
      if paths.empty?
        [Item.new(nil)]
      else
        paths.map { |path| Item.new(path) }
      end
  end

  def display
    lines = @item_list.map do |item|
      values = @properties.map { |property| item.send(property) }
      create_line(values, item.path)
    end
    lines << total_line unless @item_list.one?
    puts lines
  end

  private

  ITEM_WIDTH_BASE = 8
  def create_line(values, name)
    columns = values.map.with_index do |value, i|
      value.to_s.rjust(i.zero? ? ITEM_WIDTH_BASE : ITEM_WIDTH_BASE - 1)
    end
    columns << name if name
    columns.join(' ')
  end

  def total_line
    values = @properties.map { |property| @item_list.sum(&property) }
    create_line(values, 'total')
  end
end
