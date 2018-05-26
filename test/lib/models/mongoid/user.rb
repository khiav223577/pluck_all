# frozen_string_literal: true
class Mongoid::User < ActiveRecord::Base
  include Mongoid::Document

  field :name, type: String
  field :age, type: Integer
end
