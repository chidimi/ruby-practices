#!/usr/bin/env ruby
require 'optparse'
require 'date'

params = ARGV.getopts('y:', 'm:')
now = Date.today

input_year = params["y"] ? params["y"].to_i : now.year
input_month = params["m"] ? params["m"].to_i : now.month
input_date = Date.new(input_year, input_month)
input_date_last_date = Date.new(input_year, input_month, -1)

puts "      #{input_month}月 #{input_year}        "
puts "日 月 火 水 木 金 土"

input_date.upto(input_date_last_date){ |date|
  print "\s" * 3 * date.wday if date.day == 1
  print "\e[30m\e[47m" if date == now
  print date.strftime("%e") + "\e[0m" + "\s"
  print "\n" if date.saturday?
}

puts "\n"*2
