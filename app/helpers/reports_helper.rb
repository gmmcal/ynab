# frozen_string_literal: true

module ReportsHelper
  def dates(reports)
    reports.pluck(:date).uniq.sort
  end

  def values(reports)
    reports.group_by(&:name).map do |name, value|
      {
        name:,
        data: extract_data(value),
        marker: { symbol: 'circle' },
      }
    end
  end

  def category_values(reports)
    [{
      name: 'Activity',
      data: extract_data(reports),
    }, {
      name: 'Budgeted',
      data: extract_data(reports, :budgeted),
      type: :spline,
    }]
  end

  def extract_data(values, field = :activity)
    values.group_by(&:date).map do |key, value|
      [key.to_s, total(value, field)]
    end
  end

  def total(value, field)
    value.inject(0.0) { |sum, item| sum + item[field].to_f }
  end
end
