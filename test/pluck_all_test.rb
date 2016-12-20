require 'test_helper'

class PluckAllTest < Minitest::Test
	def setup
    @user = User.create(:name => 'John', :serialized_attribute => {:fb_id => 141242512})
  end
  def test_that_it_has_a_version_number
    refute_nil ::PluckAll::VERSION
  end
end
