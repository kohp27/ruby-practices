#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require_relative 'item_list'

require 'io/console'
require 'optparse'
require 'pathname'

OPTIONS_MAP = {
  dotfiles: 'a',
  long: 'l',
  reverse: 'r'
}.freeze

def parse_options
  options = OPTIONS_MAP.keys.map { |key| [key, false] }.to_h

  OptionParser.new do |opts|
    OPTIONS_MAP.each do |keyword, opt|
      opts.on("-#{opt}") { options[keyword] = true }
    end
    options[:path] = opts.parse(ARGV)[0] || '.'
  end
  options
end

options = parse_options
console_witdh = IO.console.winsize[1]
ItemList.new(**options).display(console_witdh)
