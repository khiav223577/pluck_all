# frozen_string_literal: true
require_relative 'active_record_test_helper'

class ActiveRecordImmutableTest < Minitest::Test
  def test_with_includes
    relation = Post.includes(:user).limit(1)
    relation.pluck_all(:id)

    assert_equal [:user], relation.includes_values

    relation.includes_values = []
    assert_equal [], relation.includes_values
  end

  def test_with_where
    relation = Post.where(id: 1).limit(1)
    relation.pluck_all(:id)

    assert_equal [], relation.includes_values

    relation.includes_values = []
    assert_equal [], relation.includes_values
  end
end
