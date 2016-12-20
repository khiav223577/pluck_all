require 'test_helper'

class PluckAllTest < Minitest::Test
	def setup
    
  end
  def test_that_it_has_a_version_number
    refute_nil ::PluckAll::VERSION
  end
  def test_pluck_names
  	assert_equal User.pluck_all(:name), [{'name' => 'John'}, {'name' => 'pearl'}, {'name' => 'kathenrie'}]
  end
end
