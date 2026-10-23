# frozen_string_literal: true

require "test_helper"

class ReportsHelperTest < ActionView::TestCase
  setup do
    @helper = Object.new.extend(ReportsHelper)
  end

  test "#dates returns unique sorted report dates" do
    assert_equal [ Date.new(2024, 1, 5), Date.new(2024, 1, 15) ], @helper.dates([ reports(:january_report), reports(:visible_report) ])
  end

  test "#values groups reports by category name with chart data" do
    food_report = Struct.new(:name, :date, :activity, :budgeted).new("Food", Date.new(2024, 1, 15), -200.0, 1200.0)
    rent_report = Struct.new(:name, :date, :activity, :budgeted).new("Rent", Date.new(2024, 1, 5), -75.0, 1500.0)
    result = @helper.values([ food_report, rent_report ])

    assert_equal [ "Food", "Rent" ], result.map { |entry| entry[:name] }
    assert result.all? { |entry| entry[:marker][:symbol] == "circle" }
    assert result.all? { |entry| entry[:data].is_a?(Array) }
  end

  test "#category_values builds activity and budgeted series" do
    food_report = Struct.new(:name, :date, :activity, :budgeted).new("Food", Date.new(2024, 1, 15), -200.0, 1200.0)
    rent_report = Struct.new(:name, :date, :activity, :budgeted).new("Rent", Date.new(2024, 1, 5), -75.0, 1500.0)
    result = @helper.category_values([ food_report, rent_report ])

    assert_equal [ "Activity", "Budgeted" ], result.map { |entry| entry[:name] }
    assert result[0][:data].is_a?(Array)
    assert result[1][:data].is_a?(Array)
  end

  test "#extract_data and #total aggregate metrics by date" do
    food_report = Struct.new(:name, :date, :activity, :budgeted).new("Food", Date.new(2024, 1, 15), -200.0, 1200.0)
    rent_report = Struct.new(:name, :date, :activity, :budgeted).new("Rent", Date.new(2024, 1, 5), -75.0, 1500.0)

    extracted = @helper.extract_data([ food_report, rent_report ], :activity)
    total_activity = @helper.total([ food_report, rent_report ], :activity)

    assert_equal [ "2024-01-05", "2024-01-15" ].sort, extracted.map(&:first).sort
    assert_equal -275.0, total_activity
  end
end
