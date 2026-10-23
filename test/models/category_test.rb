# frozen_string_literal: true

require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test ".visible returns only visible categories" do
    visible_category = categories(:visible_category)
    hidden_category = categories(:hidden_category)

    result = Category.visible

    assert_includes result, visible_category
    assert_not_includes result, hidden_category
  end
end
