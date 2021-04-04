#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
class Counter
  attr_reader :line_counter, :words_counter, :byte_counter

  def initialize(l_option, no_parameter)
    @line_counter = 0
    @words_counter = 0
    @byte_counter = 0
    @l_option = l_option
    @no_parameter = no_parameter
  end

  def show_counter(filename)
    print format(@line_counter)
    unless @l_option
      print format(@words_counter)
      print format(@byte_counter)
    end
    print " #{filename}" unless @no_parameter
    print "\n"
  end

  def add_line_counter(num)
    @line_counter += num
  end

  def add_words_counter(num)
    @words_counter += num
  end

  def add_byte_counter(num)
    @byte_counter += num
  end

  def format(num)
    num.to_s.rjust(8)
  end
end

def main
  params = ARGV.getopts('l')
  l_option = params['l']
  total_flag = ARGV.size >= 2
  no_parameter = ARGV.size.zero?
  execute(l_option, no_parameter, total_flag)
end

def execute(l_option, no_parameter, total_flag)
  counter = Counter.new(l_option, no_parameter)
  total_counter = Counter.new(l_option, no_parameter)
  ARGF.each_line do |line|
    counter.add_line_counter(1)
    counter.add_words_counter(line.split(/\s+/).count { |str| str != '' })
    counter.add_byte_counter(line.bytesize)

    next unless ARGF.eof?

    counter.show_counter(ARGF.filename)
    total_counter.add_line_counter(counter.line_counter)
    total_counter.add_words_counter(counter.words_counter)
    total_counter.add_byte_counter(counter.byte_counter)

    counter = Counter.new(l_option, no_parameter)
  end
  total_counter.show_counter('total') if total_flag
end

main
