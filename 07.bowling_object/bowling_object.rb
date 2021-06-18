# frozen_string_literal: true

class Game
  def initialize(shots_text)
    shots_array = shots_text.split(',')
    @frames = Array.new(9) do
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
    (0..9).each do |n|
      frame, next_frame, after_next_frame = @frames.slice(n, 3)
      total += frame.score(next_frame, after_next_frame)
    end
    total
  end
end

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  PERFECT = 10

  def initialize(first_mark, second_mark = 0, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score(next_frame, after_next_frame)
    total = 0
    total += @first_shot.score + @second_shot.score + @third_shot.score
    total += next_frame.first_shot.score + next_frame.second_shot.score if !next_frame.nil? && strike?
    total += next_frame.first_shot.score if !next_frame.nil? && spare?
    total += after_next_frame.first_shot.score if !after_next_frame.nil? && strike? && next_frame.strike?
    total
  end

  def strike?
    @first_shot.score == PERFECT
  end

  def spare?
    !strike? && (@first_shot.score + @second_shot.score) == PERFECT
  end
end

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if @mark == 'X'

    @mark.to_i
  end
end
