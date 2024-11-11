# frozen_string_literal: true

class Importer
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def process
    ActiveRecord::Base.transaction { process_months }
    Rails.logger.info { "Data successfully imported" }
  end

  private

  def cleanup
    Rails.logger.info { "Cleaning old reports" }
    Report.delete_all
  end

  def months
    api.months.get_budget_months(budget.id).data.months
  end

  def categories(month)
    api.months.get_budget_month(budget.id, month).data.month.categories
  end

  def parent(name)
    Category.find_or_create_by(name:)
  end

  def update_category(category, note, visible)
    Rails.logger.info { "Updating #{category.name}" }
    category.note = note
    category.visible = visible
    category.save
  end

  def create(category, month)
    Rails.logger.info { "Creating report for #{category.name} on #{month}" }
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
    budgets.select { |budget| budget.name == "Personal" }.first
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
    update_category(parent(category.name), category.note, !category.hidden)
    create(category, month)
  end
end
