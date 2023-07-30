# frozen_string_literal: true

require 'rails_compatibility/setup_autoload_paths'
RailsCompatibility.setup_autoload_paths [File.expand_path('../models/', __FILE__)]

User.delete_all
User.create(name: 'Pearl Shi', age: 18)
User.create(name: 'Rumble Huang', age: 20)
User.create(name: 'Khiav Reoy', age: 20)
