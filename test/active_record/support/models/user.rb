# frozen_string_literal: true
class User < ActiveRecord::Base
  serialize :serialized_attribute, Hash
  mount_uploader :profile_pic, ProfilePictureUploader
  mount_uploader :pet_pic, PetPictureUploader
  has_many :posts
end
