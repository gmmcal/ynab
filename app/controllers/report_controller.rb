# frozen_string_literal: true

class ReportController < SecuredController
  before_action :report, :load_category, :year
  def index; end

  def all
    @reports = @report.with_visible_categories.select(:date, :activity, :category_id, :name)
  end

  def yearly
    @reports = @report.with_visible_categories.select(:date, :activity, :category_id, :name)
  end

  def category
    @reports = @report.select(:date, :activity, :budgeted)
  end

  private

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
    @report = @report.within_range(date.all_year)
  end
end
