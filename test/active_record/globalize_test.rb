# frozen_string_literal: true
require_relative 'active_record_test_helper'

class ActiveRecordGlobalizeTest < Minitest::Test
  def test_pluck_all
    assert_equal([
      { 'title' => 'What is your favorite food?' },
      { 'title' => 'Why did you purchase this product?' },
    ], Questionnaire.with_translations(:en).pluck_all(:title))

    assert_equal([
      { 'title' => '你最愛的食物為何？' },
    ], Questionnaire.with_translations(:'zh-TW').pluck_all(:title))
  end
end
