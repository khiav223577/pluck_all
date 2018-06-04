# frozen_string_literal: true
require_relative 'active_record_test_helper'

class ActiveRecordPluckAllTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PluckAll::VERSION
  end

  def test_pluck_none
    user_none = (ActiveRecord::Base.respond_to?(:none) ? User.none : User.where('1=0'))
    assert_equal([], user_none.pluck_all(:id, :name))
  end

  def test_pluck_one_column
    assert_equal([{'name' => 'John'}, {'name' => 'Pearl'}, {'name' => 'Kathenrie'}], User.pluck_all(:name))
  end

  def test_pluck_multiple_columns
    assert_equal([
      {'name' => 'John', 'email' => 'john@example.com'},
      {'name' => 'Pearl', 'email' => 'pearl@example.com'},
      {'name' => 'Kathenrie', 'email' => 'kathenrie@example.com'},
    ], User.pluck_all(:name, :email))
  end

  def test_pluck_with_join
    assert_equal([
      {'name' => 'John', 'title' => "John's post1"},
      {'name' => 'John', 'title' => "John's post2"},
      {'name' => 'John', 'title' => "John's post3"},
    ], User.where(:name => 'John').joins(:posts).pluck_all(:name, :title))
  end

  def test_pluck_with_associations
    assert_equal([
      {'title' => "John's post1"},
      {'title' => "John's post2"},
      {'title' => "John's post3"},
    ], User.where(:name => 'John').first.posts.pluck_all(:title))
  end

  def test_pluck_serialized_attribute
    assert_equal([
      {'serialized_attribute' => {}},
      {'serialized_attribute' => {:testing => true, :deep => {:deep => :deep}}},
    ], User.where(:name => %w(John Pearl)).pluck_all(:serialized_attribute))
  end

  def test_join
    assert_equal([
      {'name' => 'John', 'title' => "John's post1"},
      {'name' => 'John', 'title' => "John's post2"},
      {'name' => 'John', 'title' => "John's post3"},
    ], User.joins(:posts).where(:name => 'John').pluck_all(:name, :title))
  end

  def test_join_with_table_name
    assert_equal([
      {'name' => 'John', 'title' => "John's post1"},
      {'name' => 'John', 'title' => "John's post2"},
      {'name' => 'John', 'title' => "John's post3"},
    ], User.joins(:posts).where(:name => 'John').pluck_all(:'users.name', :'posts.title'))
  end

  def test_alias
    assert_equal([
      {'user_name' => 'Pearl', 'post_title' => "Pearl's post1"},
      {'user_name' => 'Pearl', 'post_title' => "Pearl's post2"},
    ], User.joins(:posts).where(:'name' => 'Pearl').pluck_all(:'users.name AS user_name', :'title AS post_title'))
  end
end
