require 'carrierwave'
require 'carrierwave/orm/activerecord'
CarrierWave.root = 'carrier_wave/test'
class ProfilePictureUploader < CarrierWave::Uploader::Base
  def store_dir
    return "/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.name}"
  end
  version :tiny do

  end
  def filename
    "profile.#{file.extension.downcase}" if original_filename.present?
  end
end
