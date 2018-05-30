# frozen_string_literal: true
require_relative "mongoid_test_helper"

if defined?(Mongoid)
  class MongoidPluckAllTest < Minitest::Test
    def test_pluck_none
      return if not User.respond_to?(:none) # Rails 3 doesn't have #none
      assert_equal([], User.none.pluck_array(:id, :name))
      assert_equal([], User.none.pluck_all(:id, :name))
    end

    def test_pluck_one_column
      assert_equal(['Pearl Shi', 'Rumble Huang', 'Khiav Reoy'], User.pluck_array(:name))
      assert_equal([
        {'name' => 'Pearl Shi'},
        {'name' => 'Rumble Huang'},
        {'name' => 'Khiav Reoy'},
      ], User.pluck_all(:name))
    end

    def test_pluck_multiple_columns
      assert_equal([['Pearl Shi', 18], ['Rumble Huang', 20], ['Khiav Reoy', 20]], User.pluck_array(:name, :age))
      assert_equal([
        {'name' => 'Pearl Shi'   , 'age' => 18},
        {'name' => 'Rumble Huang', 'age' => 20},
        {'name' => 'Khiav Reoy'  , 'age' => 20},
      ], User.pluck_all(:name, :age))
    end

    def test_pluck_with_condition
      assert_equal(['Rumble Huang', 'Khiav Reoy'], User.where(age: 20).pluck_array(:name))
      assert_equal([
        {'name' => 'Rumble Huang'},
        {'name' => 'Khiav Reoy'},
      ], User.where(age: 20).pluck_all(:name))
    end
  end
end
