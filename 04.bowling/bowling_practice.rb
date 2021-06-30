#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |n|
  if n != 'X'
    shots << n.to_i
  elsif n == 'X' && shots.size.odd?
    shots << 10
  else
    shots << 10
    shots << 0 if shots.size < 18
  end
end

frames = []
shots.first(18).each_slice(2) do |n|
  frames << n
end
frames << shots.slice(18..20)

point = 0
frames.each.with_index do |frame, i|
  if frame[0] == 10 && frame.size == 2
    point += frames[i + 1][0]
    point +=
      if frames[i + 1][0] == 10 && frames[i + 1].size == 2
        frames[i + 2][0]
      else
        frames[i + 1][1]
      end
  elsif frame.sum == 10 && frame.size == 2
    point += frames[i + 1][0]
  end
  point += frame.sum
end

puts point
