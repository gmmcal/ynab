# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "#years returns unique sorted years from all reports" do
    helper = Object.new.extend(ApplicationHelper)
    visible_category = Category.find_by!(name: "Food")
    Report.create!(category: visible_category, budgeted: 100.0, activity: 20.0, balance: 120.0, date: Date.new(2023, 12, 1))

    assert_equal [ 2023, 2024 ], helper.years
  end

  test "#categories returns all visible category names sorted" do
    helper = Object.new.extend(ApplicationHelper)

    assert_equal [ "Food", "Rent" ], helper.categories
  end
end
