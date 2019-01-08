# frozen_string_literal: true
require 'test_helper'
require_relative 'carrierwave_test_helper'

ActiveRecord::Base.establish_connection(
  'adapter'  => 'sqlite3',
  'database' => ':memory:',
)

require_relative 'support/seeds'
