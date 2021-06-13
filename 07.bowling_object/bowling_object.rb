# frozen_string_literal: true

class Game
  def initialize(shots)
    shots_array = shots.split(',')
    @frames = []
    while @frames.size < 9
      shot = shots_array.shift
      @frames << if shot == 'X'
                   Frame.new(shot)
                 else
                   Frame.new(shot, shots_array.shift)
                 end
    end
    @frames << Frame.new(*shots_array)
  end

  def score
    total = 0
    @current_frame_count = 0

    @frames.each do |frame|
      @current_frame_count += 1

      total += frame.score
      total += frame.first_shot.score + frame.second_shot.score if prev_frame_strike?
      total += frame.first_shot.score if prev_frame_spare?
      total += frame.first_shot.score if strike_two_consecutive?
    end
    total
  end

  private

  def prev_frame_strike?
    @current_frame_count > 1 && @frames[@current_frame_count - 2].strike?
  end

  def prev_frame_spare?
    @current_frame_count > 1 && @frames[@current_frame_count - 2].spare?
  end

  def strike_two_consecutive?
    @current_frame_count > 2 && @frames[@current_frame_count - 2].strike? && @frames[@current_frame_count - 3].strike?
  end
end

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = 0, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    !strike? && (@first_shot.score + @second_shot.score) == 10
  end
end

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark == 'X'

    mark.to_i
  end
end
