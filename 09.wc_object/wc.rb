#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require_relative 'item_list'

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.on('-l') { options[:l] = true }
    options[:paths] = opts.parse(ARGV)
  end
  options
end

options = parse_options
ItemList.new(options[:paths], options[:l]).display
