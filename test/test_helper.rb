require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pluck_all'

require 'minitest/autorun'

ActiveRecord::Base.establish_connection(
  "adapter"  => "mysql2",
  "database" => "travis_ci_test",
)
require_relative 'seeds'
