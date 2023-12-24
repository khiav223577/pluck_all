# frozen_string_literal: true
require_relative 'active_record_test_helper'

class ActiveRecordPluckAllTest < Minitest::Test
  def setup
    @users = User.where(name: %w[Pearl Doggy])
  end

  def test_pluck_with_carrierwave
    assert_equal([
      { 'name' => 'Pearl', 'profile_pic' => nil },
      { 'name' => 'Doggy', 'profile_pic' => '/uploads/user/profile_pic/Doggy/Profile.jpg' },
    ], @users.cast_need_columns(%i[name]).pluck_all(:name, :profile_pic).each do |s|
      s['profile_pic'] = s['profile_pic'].url
    end)
    assert_equal([
      { 'name' => 'Pearl', 'profile_pic' => nil },
      { 'name' => 'Doggy', 'profile_pic' => '/uploads/user/profile_pic/Doggy/tiny_Profile.jpg' },
    ], @users.cast_need_columns(%i[name]).pluck_all(:name, :profile_pic).each do |s|
      s['profile_pic'] = s['profile_pic'].tiny.url
    end)
  end

  def test_pluck_with_carrierwave_and_different_pics
    assert_equal([
      { 'name' => 'John', 'profile_pic' => '/uploads/user/profile_pic/John/JohnProfile.jpg', 'pet_pic' => nil },
      { 'name' => 'Pearl', 'profile_pic' => nil, 'pet_pic' => nil },
      { 'name' => 'Doggy', 'profile_pic' => '/uploads/user/profile_pic/Doggy/Profile.jpg', 'pet_pic' => '/uploads/user/pet_pic/Doggy/Pet.png' },
    ], User.cast_need_columns(%i[name]).pluck_all(:name, :profile_pic, :pet_pic).each do |s|
      s['profile_pic'] = s['profile_pic'].url
      s['pet_pic'] = s['pet_pic'].url
    end)
  end

  def test_pluck_without_carrierwave
    const = Object.send(:remove_const, :CarrierWave)
    assert_equal([
      { 'name' => 'Pearl', 'profile_pic' => nil },
      { 'name' => 'Doggy', 'profile_pic' => 'Profile.jpg' },
    ], @users.cast_need_columns(%i[name]).pluck_all(:name, :profile_pic))
    Object.const_set(:CarrierWave, const)
  end

  def test_pluck_without_cast_need_columns
    error = assert_raises(ActiveModel::MissingAttributeError){ @users.pluck_all(:name, :pet_pic) }

    if Gem::Version.new(ActiveRecord::VERSION::STRING) >= Gem::Version.new('7.1.0')
      assert_equal "missing attribute 'name' for User", error.message
    else
      assert_equal 'missing attribute: name', error.message
    end
  end

  def test_pluck_with_carrierwave_and_join
    excepted = [
      { 'name' => 'Pearl', 'profile_pic' => nil, 'post_name' => 'post4' },
      { 'name' => 'Pearl', 'profile_pic' => nil, 'post_name' => 'post5' },
      { 'name' => 'Doggy', 'profile_pic' => '/uploads/user/profile_pic/Doggy/Profile.jpg', 'post_name' => 'post6' },
    ]
    attributes = [:'users.name AS name', :'posts.name AS post_name', :profile_pic]
    assert_equal(excepted, User.joins(:posts).where('users.name': %w[Pearl Doggy]).cast_need_columns(%i[name]).pluck_all(*attributes).each do |s|
      s['profile_pic'] = s['profile_pic'].url
    end)
    assert_equal(excepted, Post.joins(:user).where('users.name': %w[Pearl Doggy]).cast_need_columns(%i[name], User).pluck_all(*attributes).each do |s|
      s['profile_pic'] = s['profile_pic'].url
    end)
  end
end
