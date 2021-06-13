require 'minitest/autorun'
require_relative './bowling_object'

MiniTest::Unit.autorun

class TestBowling < MiniTest::Unit::TestCase
  def setup
    @game1 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    @game2 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    @game3 = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    @game4 = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    @game5 = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
  end

  def test_bowling
    assert_equal 139, @game1.score
    assert_equal 164, @game2.score
    assert_equal 107, @game3.score
    assert_equal 134, @game4.score
    assert_equal 300, @game5.score
  end
end
