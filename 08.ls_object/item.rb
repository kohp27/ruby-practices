# frozen_string_literal: true

require 'etc'

class Item
  def initialize(input_path, dir)
    @path = File.join(dir, input_path)
    @lstat = File.lstat(@path)
  end

  def filetype
    type = @lstat.ftype

    case type
    when 'file', 'unknown' then '-'
    when 'fifo' then 'p'
    else type[0]
    end
  end

  def permissions
    (%w[x w r] * 3).map.with_index do |c, i|
      (@lstat.mode >> i & 1).zero? ? '-' : c
    end.reverse.join
  end

  def nlink
    @lstat.nlink
  end

  def user
    Etc.getpwuid(@lstat.uid).name
  end

  def group
    Etc.getgrgid(@lstat.gid).name
  end

  def size
    @lstat.size
  end

  def blocks
    @lstat.blocks
  end

  HARF_YEAR = 60 * 60 * 24 * 182
  def updated_date
    time = @lstat.mtime
    time_format = Time.now - time < HARF_YEAR ? '%_m %_d %H:%M' : '%_m %_d %_5Y'
    time.strftime(time_format)
  end

  def filename
    File.basename(@path)
  end

  def name_with_link_destination
    if @lstat.ftype == 'link'
      link_destination = File.readlink(@path)
      "#{filename} -> #{link_destination}"
    else
      filename
    end
  end
end
