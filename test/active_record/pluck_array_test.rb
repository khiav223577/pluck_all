# frozen_string_literal: true
require_relative 'active_record_test_helper'

class ActiveRecordPluckArrayTest < Minitest::Test
  def setup
  end

  def test_pluck_one_column
    assert_equal(%w[John Pearl Kathenrie], User.pluck_array(:name))
  end

  def test_pluck_multiple_columns
    assert_equal([
      ['John', 'john@example.com'],
      ['Pearl', 'pearl@example.com'],
      ['Kathenrie', 'kathenrie@example.com'],
    ], User.pluck_array(:name, :email))
  end

  def test_pluck_multiple_columns_with_nil_value
    assert_equal([
      ['John', nil],
      ['Pearl', nil],
      ['Kathenrie', 'Pet.png'],
    ], User.pluck_array(:name, :pet_pic))
  end

  def test_pluck_serialized_attribute
    assert_equal([
      {},
      { testing: true, deep: { deep: :deep }},
    ], User.where(name: %w[John Pearl]).pluck_array(:serialized_attribute))
  end

  def test_join
    assert_equal([
      ['John', "John's post1"],
      ['John', "John's post2"],
      ['John', "John's post3"],
    ], User.joins(:posts).where(name: 'John').pluck_array(:name, :title))
  end

  def test_join_with_table_name
    columns = ['users.name', 'posts.title'] # sqlite3 has problem with this, can only use string instead of symbol.
    assert_equal([
      ['John', "John's post1"],
      ['John', "John's post2"],
      ['John', "John's post3"],
    ], User.joins(:posts).where(name: 'John').pluck_array(*columns))
  end

  def test_alias
    columns = ['users.name AS user_name', 'title AS post_title'] # Rails 5 has problem with this, can only use string instead of symbol.
    assert_equal([
      ['Pearl', "Pearl's post1"],
      ['Pearl', "Pearl's post2"],
    ], User.joins(:posts).where(name: 'Pearl').pluck_array(*columns))
  end

  def test_pluck_with_includes
    skip if ActiveRecord::VERSION::MAJOR < 4 # Rails 3's includes + pluck will not become left outer joins
    posts = Post.includes(:user).where(users: { name: 'Pearl' })
    assert_equal posts.pluck(:id), posts.pluck_array(:id)
  end
end
