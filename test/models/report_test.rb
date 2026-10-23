# frozen_string_literal: true

require "test_helper"

class ReportTest < ActiveSupport::TestCase
  test ".with_visible_categories includes only visible categories" do
    visible_report = reports(:visible_report)
    hidden_report = reports(:hidden_report)

    result = Report.with_visible_categories

    assert_includes result, visible_report
    assert_not_includes result, hidden_report
  end

  test ".within_range returns reports in the requested date range" do
    january_report = reports(:january_report)
    hidden_report = reports(:hidden_report)
    range = Date.new(2024, 1, 1)..Date.new(2024, 1, 31)

    result = Report.within_range(range)

    assert_includes result, january_report
    assert_not_includes result, hidden_report
  end
end
