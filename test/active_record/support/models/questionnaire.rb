# frozen_string_literal: true

require 'globalize'
class Questionnaire < ActiveRecord::Base
  translates :title
end
