# frozen_string_literal: true
require 'test_helper'
require 'mongoid'

Mongoid::Config.connect_to('pluck_all_test')
require_relative 'lib/mongoid_seeds'
