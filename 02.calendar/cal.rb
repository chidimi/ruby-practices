#!/usr/bin/env ruby
require 'optparse'
require 'date'

opt = OptionParser.new
opt.on('-y')
opt.on('-m')
opt.parse!(ARGV)

now = Date.today
input_year = ARGV[0] ? ARGV[0].to_i : now.year.to_i
input_month = ARGV[1] ? ARGV[1].to_i : now.month.to_i
input_date = Date.new(input_year, input_month)
input_date_last_date = Date.new(input_year, input_month, -1)

puts "      #{input_month}月 #{input_year}        "
puts "日 月 火 水 木 金 土"

input_date.upto(input_date_last_date){ |date|
  print "\s" * 3 * date.wday if date.day == 1
  print date.strftime("%e ")
  print "\n" if date.saturday?
}

puts "\n"
