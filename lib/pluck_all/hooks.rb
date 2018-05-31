module PluckAll
  class Hooks
    def self.init
      # ActiveRecord
      begin
        require 'active_record'
        require 'pluck_all/models/active_record_extension'
        # ::ActiveRecord.send(:include, PluckAll::ActiveRecordExtension)
      rescue LoadError, Gem::LoadError
      end

      # Mongoid
      begin
        require 'mongoid'
        require 'pluck_all/models/mongoid_extension'
        # ::Mongoid::Document.send(:include, PluckAll::MongoidExtension)
      rescue LoadError, Gem::LoadError
      end
    end
  end
end

PluckAll::Hooks.init
