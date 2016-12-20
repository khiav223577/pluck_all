require 'test_helper'

class PluckAllTest < Minitest::Test
	def setup
    
  end
  def test_that_it_has_a_version_number
    refute_nil ::PluckAll::VERSION
  end
  def test_pluck_one_column
  	assert_equal User.pluck_all(:name), [{'name' => 'John'}, {'name' => 'pearl'}, {'name' => 'kathenrie'}]
  end
  def test_pluck_serialized_attribute
  	assert_equal User.where(:name => %w(John pearl)).pluck_all(:serialized_attribute), [{'serialized_attribute' => {}}, {'serialized_attribute' => {:testing => true, :deep => {:deep => :deep}}}]
  end
end
