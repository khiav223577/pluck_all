Mongoid::Config.connect_to('pluck_all_test')
module Mongoid
  def self.table_name_prefix
    'mongoid_'
  end
end

ActiveSupport::Dependencies.autoload_paths << File.expand_path('../models/', __FILE__)
