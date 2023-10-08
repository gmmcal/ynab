# frozen_string_literal: true

class ReportController < ApplicationController
  before_action :report, :load_category, :year
  def index; end

  def all
    reports = @report.with_visible_categories.select(:date, :activity, :category_id, :name)
    @dates = reports.pluck(:date).uniq.sort
    @values = reports.group_by(&:name).map do |name, value|
      {
        name: name,
        data: extract_data(value),
        marker: { symbol: 'circle' },
      }
    end
  end

  def yearly
    reports = @report.with_visible_categories.select(:date, :activity, :category_id, :name)
    @dates = reports.pluck(:date).uniq.sort
    @values = reports.group_by(&:name).map do |name, value|
      {
        name: name,
        data: extract_data(value),
        marker: { symbol: 'circle' },
      }
    end
  end

  def category
    reports = @report.select(:date, :activity)
    @dates = reports.pluck(:date).uniq.sort
    @values = [{
      name: @category.name,
      data: extract_data(reports),
    }]
  end

  private

  def extract_data(values)
    values.group_by(&:date).map do |key, value|
      [key.to_s, value.inject(0.0) { |sum, item| sum + item.activity.to_f }]
    end
  end

  def date
    return "#{params[:year]}-01-01".to_date if params[:year]

    Time.zone.today
  end

  def load_category
    return unless params[:category]

    @category = Category.find_by(name: params[:category])
    @report = @report.where(category: @category)
  end

  def report
    @report = Report.order(:date)
  end

  def year
    return unless params[:year]

    @year = date.year
    @report = @report.within_range(range)
  end

  def range
    date.all_year
  end
end
