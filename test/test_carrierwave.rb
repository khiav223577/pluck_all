# frozen_string_literal: true
require 'test_helper'

class PluckAllTest < Minitest::Test
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
