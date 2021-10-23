class ReportController < ApplicationController
  def index
    date = Date.today
    if params[:year]
      date = "#{params[:year]}-01-01".to_date
    end
    @year = date.year
    @report = Report.all
    if params[:category]
      @category = Category.find_by(name: params[:category])
      @report = @report.where(category: @category)
    end
    @categories = Category.visible.map(&:name).uniq.sort
    @years = Report.all.map { |r| r.date.year }.uniq.sort
    range = (date.beginning_of_year..date.end_of_year)
    @data = @report.includes(:category).where(category: { visible: true }).where(date: range).group(:name).group_by_month(:date).sum(:activity)
  end
end
