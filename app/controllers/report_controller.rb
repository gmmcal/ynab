# frozen_string_literal: true

class ReportController < ApplicationController
  before_action :year, :report, :category
  def index
    @data = @report.with_visible_categories.within_range(range).grouped.sum(:activity)
  end

  private

  def date
    return "#{params[:year]}-01-01".to_date if params[:year]

    Time.zone.today
  end

  def category
    return unless params[:category]

    @category = Category.find_by(name: params[:category])
    @report = @report.where(category: @category)
  end

  def report
    @report = Report.all
  end

  def year
    @year = date.year
  end

  def range
    date.all_year
  end
end
