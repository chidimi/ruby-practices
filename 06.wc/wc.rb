#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

total_flag = ARGV.size >= 2
no_parameter = ARGV.size.zero?
params = ARGV.getopts('l:')

line_counter = 0
words_counter = 0
byte_counter = 0
total_line_counter = 0
total_words_counter = 0
total_byte_counter = 0

ARGF.each do |line|
  line_counter += 1
  words = line.split(/\s+/).reject(&:empty?)
  words_counter += words.size
  byte_counter += line.bytesize

  next unless ARGF.eof?

  print line_counter.to_s.rjust(8)
  print words_counter.to_s.rjust(8) unless params['l']
  print byte_counter.to_s.rjust(8) unless params['l']
  print " #{ARGF.filename}" unless no_parameter
  print "\n"

  total_line_counter += line_counter
  total_words_counter += words_counter
  total_byte_counter += byte_counter

  line_counter = 0
  words_counter = 0
  byte_counter = 0
end
if total_flag
  print total_line_counter.to_s.rjust(8)
  print total_words_counter.to_s.rjust(8)
  print total_byte_counter.to_s.rjust(8)
  print ' total'
  print "\n"
end
