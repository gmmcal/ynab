# frozen_string_literal: true

module ApplicationHelper
  def years
    Report.all.map { |report| report.date.year }.uniq.sort
  end

  def categories
    Category.visible.map(&:name).uniq.sort
  end
end
