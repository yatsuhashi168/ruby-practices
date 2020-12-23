#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'

date = Date.today
month = date.month
year = date.year

require 'optparse'
opt = OptionParser.new

opt.on('-y VAL', 'set a year') { |v| year = v.to_i }
opt.on('-m VAL', 'set a month') { |v| month = v.to_i }

opt.parse!(ARGV)

puts "#{month}月 #{year}".center(18)
weekdays = %w[日 月 火 水 木 金 土]
weekdays.each do |weekday|
  print weekday.center(2)
end
puts

firstday = Date.new(year, month, 1)
lastday = Date.new(year, month, -1)
countday = firstday
brankday = firstday

while countday.day != lastday.day

  while brankday.wday != 0
    print ''.center(3)
    brankday -= 1
  end

  print countday.day.to_s.center(3)
  puts if countday.wday == 6

  countday += 1
end

puts
