# frozen_string_literal: true

require_relative './bowling'
require 'minitest/autorun'

class BowlingTest < Minitest::Test
  def test_bowling
    assert_equal 139, get_point('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 164, get_point('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 107, get_point('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 134, get_point('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 300, get_point('X,X,X,X,X,X,X,X,X,X,X,X')
  end
end
