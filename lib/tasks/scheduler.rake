namespace :ynab do
  desc "TODO"
  task import: :environment do
    access_token = ENV['YNAB_TOKEN']
    ynab_api = YNAB::API.new(access_token)
    begin
      budget_response = ynab_api.budgets.get_budgets
      budget = budget_response.data.budgets.first
      ActiveRecord::Base.transaction do
        Report.delete_all
        ynab_api.months.get_budget_months(budget.id).data.months.each do |month|
          ynab_api.months.get_budget_month(budget.id, month.month).data.month.categories.each do |category|
            parent = Category.find_or_create_by(name: category.name)
            parent.note = category.note
            parent.save
            Report.create(
              category: parent,
              budgeted: category.budgeted / 1000.0,
              activity: (category.activity * -1) / 1000.0,
              balance: category.balance / 1000.0,
              date: month.month,
            )
          end
        end
      end
    rescue => e
      puts "ERROR: id=#{e.id}; name=#{e.name}; detail: #{e.detail}"
    end
  end
end
