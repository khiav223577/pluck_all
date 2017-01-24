require 'test_helper'

class PluckAllTest < Minitest::Test
  def setup
    
  end
  def test_that_it_has_a_version_number
    refute_nil ::PluckAll::VERSION
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
#-------------------------------------------
#  Test CarrierWave
#-------------------------------------------
  def test_pluck_with_carrierwave
    assert_equal([
      {'name' => 'Pearl'    , 'profile_pic' => nil},
      {'name' => 'Kathenrie', 'profile_pic' => "/uploads/user/profile_pic/Kathenrie/Profile.jpg"},
    ], User.where(:name => %w(Pearl Kathenrie)).cast_need_columns(%i(name)).pluck_all(:name, :'profile_pic').each{|s| 
      s['profile_pic'] = s['profile_pic'].url
    })
    assert_equal([
      {'name' => 'Pearl'    , 'profile_pic' => nil},
      {'name' => 'Kathenrie', 'profile_pic' => "/uploads/user/profile_pic/Kathenrie/tiny_Profile.jpg"},
    ], User.where(:name => %w(Pearl Kathenrie)).cast_need_columns(%i(name)).pluck_all(:name, :'profile_pic').each{|s| 
      s['profile_pic'] = s['profile_pic'].tiny.url
    })
  end
  def test_pluck_with_carrierwave_and_different_pics
    assert_equal([
      {'name' => 'John'     , 'profile_pic' => "/uploads/user/profile_pic/John/JohnProfile.jpg", 'pet_pic' => nil},
      {'name' => 'Pearl'    , 'profile_pic' => nil, 'pet_pic' => nil},
      {'name' => 'Kathenrie', 'profile_pic' => "/uploads/user/profile_pic/Kathenrie/Profile.jpg", 'pet_pic' => "/uploads/user/pet_pic/Kathenrie/Pet.png"},
    ], User.cast_need_columns(%i(name)).pluck_all(:name, :'profile_pic', :'pet_pic').each{|s| 
      s['profile_pic'] = s['profile_pic'].url
      s['pet_pic'] = s['pet_pic'].url
    })
  end
  def test_pluck_without_carrierwave
    const = Object.send(:remove_const, :CarrierWave)
    assert_equal([
      {'name' => 'Pearl', 'profile_pic' => nil},
      {'name' => 'Kathenrie', 'profile_pic' => "Profile.jpg"},
    ], User.where(:name => %w(Pearl Kathenrie)).cast_need_columns(%i(name)).pluck_all(:name, :'profile_pic'))
    Object.const_set(:CarrierWave, const)
  end
  def test_pluck_without_cast_need_columns
    assert_equal([
      {'name' => 'Pearl', 'pet_pic' => nil},
      {'name' => 'Kathenrie', 'pet_pic' => "/uploads/user/pet_pic/Pet.png"},
    ], User.where(:name => %w(Pearl Kathenrie)).pluck_all(:name, :'pet_pic').each{|s| 
      s['pet_pic'] = s['pet_pic'].url
    })
  end
  def test_pluck_with_carrierwave_and_join
    excepted = [
      {'name' => 'Pearl', 'profile_pic' => nil, 'post_name' => 'post4'},
      {'name' => 'Pearl', 'profile_pic' => nil, 'post_name' => 'post5'},
      {'name' => 'Kathenrie', 'profile_pic' => "/uploads/user/profile_pic/Kathenrie/Profile.jpg", 'post_name' => 'post6'},
    ]
    attributes = [:'users.name AS name', :'posts.name AS post_name', :'profile_pic']
    assert_equal(excepted, User.joins(:posts).where(:'users.name' => %w(Pearl Kathenrie)).cast_need_columns(%i(name)).pluck_all(*attributes).each{|s| 
      s['profile_pic'] = s['profile_pic'].url
    })
    assert_equal(excepted, Post.joins(:user).where(:'users.name' => %w(Pearl Kathenrie)).cast_need_columns(%i(name), User).pluck_all(*attributes).each{|s| 
      s['profile_pic'] = s['profile_pic'].url
    })
  end
end
