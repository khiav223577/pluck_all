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

  def test_pluck_multiple_columns
    assert_equal([['Pearl Shi', 18], ['Rumble Huang', 20], ['Khiav Reoy', 20]], Mongoid::User.pluck(:name, :age))
    assert_equal([
      {'name' => 'Pearl Shi'   , 'age' => 18},
      {'name' => 'Rumble Huang', 'age' => 20},
      {'name' => 'Khiav Reoy'  , 'age' => 20},
    ], Mongoid::User.pluck_all(:name, :age))
  end

  def test_pluck_with_condition
    assert_equal(['Rumble Huang', 'Khiav Reoy'], Mongoid::User.where(age: 20).pluck(:name))
    assert_equal([
      {'name' => 'Rumble Huang'},
      {'name' => 'Khiav Reoy'},
    ], Mongoid::User.where(age: 20).pluck_all(:name))
  end
end
