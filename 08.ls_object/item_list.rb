# frozen_string_literal: true

require 'etc'
require_relative 'item'

class ItemList
  def initialize(dotfiles:, long:, reverse:, path:)
    @dotfiles = dotfiles
    @long = long
    @reverse = reverse
    @is_path_file = File.file?(path)

    @item_list =
      if @is_path_file
        [path].map { |filename| Item.new(filename, '.', true) }
      else
        Dir.entries(path).sort.map { |filename| Item.new(filename, path, false) }
      end
  end

  def display(display_width)
    items_dotfiles_remove unless @dotfiles
    items_reverse if @reverse

    if @long
      display_long
    else
      display_short(display_width)
    end
  end

  private

  def items_dotfiles_remove
    @item_list.filter! { |item| item.item_name[0] != '.' }
  end

  def items_reverse
    @item_list.reverse!
  end

  TAB_SIZE = 8
  def display_short(display_width)
    items_cnt = @item_list.size
    item_width = TAB_SIZE * (item_properties_widthes(:item_name) / TAB_SIZE.to_f).ceil
    max_columns_cnt = display_width / item_width
    rows_cnt = (items_cnt / max_columns_cnt.to_f).ceil

    adjusted_item_names = @item_list.map(&:item_name).map do |name|
      tabs_cnt = ((item_width - name.length) / TAB_SIZE.to_f).ceil
      "#{name}#{"\t" * tabs_cnt}"
    end

    item_matrix = adjusted_item_names.each_slice(rows_cnt)
                                     .map { |names| names.values_at(0...rows_cnt) }
                                     .transpose

    puts(item_matrix.map { |names| names.join.rstrip })
  end

  def display_long
    total_block_line = "total #{@item_list.map(&:blocks).sum}"
    item_details = @item_list.map do |item|
      "#{item.filetype}#{item.permissions}  " \
      "#{item.nlink.to_s.rjust(item_properties_widthes(:nlink))} " \
      "#{item.user.ljust(item_properties_widthes(:user))}  " \
      "#{item.group.ljust(item_properties_widthes(:group))}  " \
      "#{item.size.to_s.rjust(item_properties_widthes(:size))} " \
      "#{item.updated_date} " \
      "#{item.name_with_link_destination}"
    end

    puts total_block_line unless @is_path_file
    puts item_details
  end

  CALC_WIDTH_PROPERTIED = %i[nlink user group size].freeze
  def item_properties_widthes(property)
    @item_list.map { |item| item.send(property).to_s.length }.max
  end
end
