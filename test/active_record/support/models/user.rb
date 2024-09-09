# frozen_string_literal: true
class User < ActiveRecord::Base
  if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('7.1.0')
    serialize :serialized_attribute, Hash
  else
    serialize :serialized_attribute, type: Hash
  end

  mount_uploader :profile_pic, ProfilePictureUploader
  mount_uploader :pet_pic, PetPictureUploader
  has_many :posts
end
