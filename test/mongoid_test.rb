# frozen_string_literal: true
require 'mongoid_helper'

class MongoidTest < Minitest::Test
  def test_pluck_none
    assert_equal([], Mongoid::User.none.pluck(:id, :name))
    assert_equal([], Mongoid::User.none.pluck_all(:id, :name))
  end

  def test_pluck_one_column
    assert_equal(['Pearl Shi', 'Rumble Huang', 'Khiav Reoy'], Mongoid::User.pluck(:name))
    assert_equal([
      {'name' => 'Pearl Shi'},
      {'name' => 'Rumble Huang'},
      {'name' => 'Khiav Reoy'},
    ], Mongoid::User.pluck_all(:name))
  end
end
