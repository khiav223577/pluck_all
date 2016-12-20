$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pluck_all'

require 'minitest/autorun'

ActiveRecord::Base.establish_connection(
  "adapter"  => "sqlite3",
  "database" => ":memory:"
)
require 'seeds'
