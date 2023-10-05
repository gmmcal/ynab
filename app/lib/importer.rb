# frozen_string_literal: true

class Importer
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def process
    ActiveRecord::Base.transaction do
      process_months
    end
    'Data successfully imported'
  rescue StandardError => error
    "ERROR: id=#{error.id}; name=#{error.name}; detail: #{error.detail}"
  end

  private

  def cleanup
    Report.delete_all
  end

  def months
    api.months.get_budget_months(budget.id).data.months
  end

  def categories(month)
    api.months.get_budget_month(budget.id, month).data.month.categories
  end

  def parent(name)
    Category.find_or_create_by(name: name)
  end

  def update_category(category, note)
    category.note = note
    category.save
  end

  def create(category, month)
    Report.create(
      category: parent(category.name),
      budgeted: category.budgeted / 1000.0,
      activity: (category.activity * -1) / 1000.0,
      balance: category.balance / 1000.0,
      date: month
    )
  end

  def api
    @api ||= YNAB::API.new(token)
  end

  def budget
    budgets.select { |budget| budget.name == 'Personal' }.first
  end

  def budgets
    api.budgets.get_budgets.data.budgets
  end

  def process_months
    cleanup
    months.each { |month| process_categories(month.month) }
  end

  def process_categories(month)
    categories(month).each { |category| process_category(category, month) }
  end

  def process_category(category, month)
    update_category(parent(category.name), category.note)
    create(category, month)
  end
end
