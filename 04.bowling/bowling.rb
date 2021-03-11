#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = []

frame_counter = 1
scores.each do |s|
  if s == 'X' && frame_counter < 10
    shots << 10
    shots << 0
    frame_counter += 1
  elsif s == 'X'
    shots << 10
    frame_counter += 1
  else
    shots << s.to_i
    frame_counter += 0.5
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end


point = 0
frames.each_with_index do |frame, i|
  if frame[0] == 10 # strike
    if frames[i+1][0] != 10 #次の一投がストライクでないなら
      point += 10 + frames[i+1][0] + frames[i+1][1]
    else
      point += 10 + frames[i+1][0] + frames[i+2][0]
    end
  elsif frame.sum == 10 # spare
    point += 10 + frames[i+1][0]
  else
    point += frame.sum
  end
end
puts point