# frozen_string_literal: true
require 'mongoid_helper'

class MongoidTest < Minitest::Test
  def test_pluck_none
    assert_equal([], Mongoid::User.none.pluck(:id, :name))
    assert_equal([], Mongoid::User.none.pluck_all(:id, :name))
  end
end
