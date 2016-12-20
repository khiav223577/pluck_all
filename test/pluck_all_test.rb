require 'test_helper'

class PluckAllTest < Minitest::Test
	def setup
    
  end
  def test_that_it_has_a_version_number
    refute_nil ::PluckAll::VERSION
  end
  def test_pluck_one_column
  	assert_equal User.pluck_all(:name), [{'name' => 'John'}, {'name' => 'Pearl'}, {'name' => 'Kathenrie'}]
  end
  def test_pluck_multiple_column
  	assert_equal User.pluck_all(:name, :email), [
  		{'name' => 'John', 'email' => 'john@example.com'}, 
  		{'name' => 'Pearl', 'email' => 'pearl@example.com'}, 
  		{'name' => 'Kathenrie', 'email' => 'kathenrie@example.com'},
  	]
  end
  def test_pluck_serialized_attribute
  	assert_equal User.where(:name => %w(John Pearl)).pluck_all(:serialized_attribute), [{'serialized_attribute' => {}}, {'serialized_attribute' => {:testing => true, :deep => {:deep => :deep}}}]
  end

  def test_join_and_alias_column
  	assert_equal User.joins(:posts).where(:name => 'John').pluck_all(:name, :title), [
  		{'name' => 'John', 'title' => 'John\'s post1'},
  		{'name' => 'John', 'title' => 'John\'s post2'},
  		{'name' => 'John', 'title' => 'John\'s post3'},
  	]
  	assert_equal User.joins(:posts).where(:name => 'Pearl').pluck_all(:'name AS user_name', :'title AS post_title'), [
  		{'user_name' => 'Pearl', 'post_title' => 'Pearl\'s post1'},
  	]
  end
end
