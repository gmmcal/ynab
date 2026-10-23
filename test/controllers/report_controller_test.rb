# frozen_string_literal: true

require "test_helper"

class ReportControllerTest < ActionController::TestCase
  tests ReportController

  test "all requires authentication" do
    get :all

    assert_redirected_to new_auth_path
  end

  test "index without a year uses the current date and renders the page" do
    @request.session[:authenticated] = true

    get :index

    assert_response :success
    assert_nil @controller.instance_variable_get(:@year)
  end

  test "all returns only visible reports for authenticated users" do
    @request.session[:authenticated] = true

    get :all

    visible_reports = @controller.instance_variable_get(:@reports)

    assert_response :success
    assert_includes visible_reports, reports(:visible_report)
    assert_not_includes visible_reports, reports(:hidden_report)
  end

  test "yearly filters reports by selected year" do
    @request.session[:authenticated] = true

    get :yearly, params: { year: 2024 }

    filtered_reports = @controller.instance_variable_get(:@reports)

    assert_response :success
    assert_equal 2024, @controller.instance_variable_get(:@year)
    assert_includes filtered_reports.map(&:date), Date.new(2024, 1, 15)
  end

  test "category filters results by year and category name" do
    @request.session[:authenticated] = true

    get :category, params: { year: 2024, category: "Food" }

    filtered_reports = @controller.instance_variable_get(:@reports)

    assert_response :success
    assert_equal [ Date.new(2024, 1, 15) ], filtered_reports.map(&:date)
  end
end
