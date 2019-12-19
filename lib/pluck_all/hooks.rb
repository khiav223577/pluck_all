module PluckAll
  class Hooks
    class << self

      def init
        require 'pluck_all/models/active_record_extension' if require_if_exists('active_record')
        require 'pluck_all/models/mongoid_extension' if require_if_exists('mongoid')
      end

      private

      def require_if_exists(path)
        begin
          require path
          return true
        rescue LoadError, Gem::LoadError
          return false
        end
      end
    end
  end
end

PluckAll::Hooks.init
