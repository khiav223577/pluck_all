# frozen_string_literal: true
require 'carrierwave'
require 'carrierwave/orm/activerecord'

CarrierWave.root = 'carrier_wave/test'
class ProfilePictureUploader < CarrierWave::Uploader::Base
  def store_dir
    return "/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.name}"
  end
  version :tiny do
  end
end

class PetPictureUploader < CarrierWave::Uploader::Base
  def store_dir
    return "/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.name}"
  end
end
