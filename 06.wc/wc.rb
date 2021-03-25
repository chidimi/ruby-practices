#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
class Counter
  attr_accessor :line_counter, :words_counter, :byte_counter

  def initialize(l_option, no_parameter)
    @line_counter = 0
    @words_counter = 0
    @byte_counter = 0
    @l_option = l_option
    @no_parameter = no_parameter
  end

  def show_counter(filename)
    print @line_counter.to_s.rjust(8)
    print @words_counter.to_s.rjust(8) unless @l_option
    print @byte_counter.to_s.rjust(8) unless @l_option
    print " #{filename}" unless @no_parameter
    print "\n"
  end
end

def main
  params = ARGV.getopts('l')
  l_option = params['l']
  ARGV.delete_if { |param| param == '-l' }
  total_flag = ARGV.size >= 2
  no_parameter = ARGV.size.zero?
  execute(l_option, no_parameter, total_flag)
end

def execute(l_option, no_parameter, total_flag)
  counter = Counter.new(l_option, no_parameter)
  total_counter = Counter.new(l_option, no_parameter)
  ARGF.each_line do |line|
    counter.line_counter += 1
    counter.words_counter += line.split(/\s+/).count { |str| str != '' }
    counter.byte_counter += line.bytesize
    next unless ARGF.eof?

    counter.show_counter(ARGF.filename)
    total_counter.line_counter += counter.line_counter
    total_counter.words_counter += counter.words_counter
    total_counter.byte_counter += counter.byte_counter

    counter = Counter.new(l_option, no_parameter)
  end
  total_counter.show_counter('total') if total_flag
end

main
