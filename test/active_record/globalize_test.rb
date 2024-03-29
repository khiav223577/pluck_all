# frozen_string_literal: true
require_relative 'active_record_test_helper'

class ActiveRecordGlobalizeTest < Minitest::Test
  def setup
    skip if not SUPPORT_GLOBALIZE
  end

  def test_pluck_all
    assert_equal([
      { 'title' => 'What is your favorite food?' },
      { 'title' => 'Why did you purchase this product?' },
    ], Questionnaire.with_translations(:en).pluck_all(:title))

    assert_equal([
      { 'title' => '你最愛的食物為何？' },
    ], Questionnaire.with_translations(:'zh-TW').pluck_all(:title))
  end

  def test_pluck_all_with_auto_join
    I18n.with_locale(:en) do
      assert_equal([
        { 'title' => 'What is your favorite food?' },
        { 'title' => 'Why did you purchase this product?' },
      ], Questionnaire.pluck_all(:title))
    end

    I18n.with_locale(:'zh-TW') do
      assert_equal([
        { 'title' => '你最愛的食物為何？' },
      ], Questionnaire.pluck_all(:title))
    end
  end
end
