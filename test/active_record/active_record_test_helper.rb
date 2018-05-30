require "test_helper"

if defined?(ActiveRecord)
  require_relative "carrierwave_test_helper"
  ActiveRecord::Base.establish_connection(
    "adapter"  => "sqlite3",
    "database" => ":memory:",
  )
  require_relative "support/seeds"
end
