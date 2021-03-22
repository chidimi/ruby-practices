# frozen_string_literal: true

def main
  score = ARGV[0]
  get_point(score)
end

def get_point(score)
  scores = score.split(',')
  shots = convert_x_to10(scores)
  frames = make_frames(shots)
  calculate_point(frames)
end

def convert_x_to10(scores)
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
  shots
end

def make_frames(shots)
  frames = shots.each_slice(2).to_a
  unless frames[10].nil? # 11フレーム目を10フレーム目に結合
    frames[9].concat(frames[10])
    frames.pop
  end
  frames
end

def calculate_point(frames)
  frames.each_with_index.sum do |frame, i|
    current_frame = i + 1
    case current_frame
    when 9
      calculate_ninth_frame(frame, frames)
    when 10
      frame.sum
    else
      calculate_first_to_eighth_frame(frame, current_frame, frames)
    end
  end
end

def calculate_ninth_frame(frame, frames)
  if frame[0] == 10 # 9フレーム目がストライクのとき
    10 + frames[9][0] + frames[9][1]
  elsif frame.sum == 10 # 9フレーム目がスペアのとき
    10 + frames[9][0]
  else
    frame.sum
  end
end

def calculate_first_to_eighth_frame(frame, current_frame, frames)
  if frame[0] == 10 && frames[current_frame][0] == 10 # strike かつ 次の一投がストライク
    10 + frames[current_frame][0] + frames[current_frame + 1][0]
  elsif frame[0] == 10
    10 + frames[current_frame][0] + frames[current_frame][1]
  elsif frame.sum == 10 # spare
    10 + frames[current_frame][0]
  else
    frame.sum
  end
end
