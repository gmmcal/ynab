# frozen_string_literal: true

require "test_helper"

class ImporterTest < ActiveSupport::TestCase
  setup do
    @importer = Importer.new("token")
  end

  test "#api instantiates the YNAB client" do
    assert_instance_of YNAB::API, @importer.send(:api)
  end

  test "#budgets returns budget data from the API" do
    api = Object.new
    def api.budgets
      self
    end

    def api.get_budgets
      Struct.new(:data).new(Struct.new(:budgets).new([ Struct.new(:name, :id).new("Personal", 42) ]))
    end

    @importer.define_singleton_method(:api) { api }

    assert_equal [ "Personal" ], @importer.send(:budgets).map(&:name)
  end

  test "#budget selects the Personal budget" do
    @importer.define_singleton_method(:budgets) { [ Struct.new(:name, :id).new("Other", 1), Struct.new(:name, :id).new("Personal", 42) ] }

    assert_equal 42, @importer.send(:budget).id
  end

  test "#months fetches month values from the YNAB API" do
    api = Object.new
    def api.months
      self
    end

    def api.get_budget_months(_budget_id)
      Struct.new(:data).new(Struct.new(:months).new([ Struct.new(:month).new("2024-01"), Struct.new(:month).new("2024-02") ]))
    end

    @importer.define_singleton_method(:api) { api }
    @importer.define_singleton_method(:budget) { Struct.new(:id).new(42) }

    assert_equal [ "2024-01", "2024-02" ], @importer.send(:months).map(&:month)
  end

  test "#categories fetches category values from the YNAB API" do
    api = Object.new
    def api.months
      self
    end

    def api.get_budget_month(_budget_id, _month)
      Struct.new(:data).new(Struct.new(:month).new(Struct.new(:categories).new([
        Struct.new(:name, :note, :hidden, :budgeted, :activity, :balance).new("Food", "Groceries", false, 2500, -1200, 1300)
      ])))
    end

    @importer.define_singleton_method(:api) { api }
    @importer.define_singleton_method(:budget) { Struct.new(:id).new(42) }

    assert_equal [ "Food" ], @importer.send(:categories, "2024-01").map(&:name)
  end

  test "#parent creates and reuses a category by name" do
    assert_equal "Food", @importer.send(:parent, "Food").name
    assert_equal @importer.send(:parent, "Food"), @importer.send(:parent, "Food")
  end

  test "#update_category persists the category note and visibility" do
    category = Category.create!(name: "Travel", note: "Old note", visible: false)

    @importer.send(:update_category, category, "Train tickets", true)

    assert_equal "Train tickets", category.reload.note
    assert_equal true, category.visible
  end

  test "#create builds a report based on the budget category payload" do
    category = Struct.new(:name, :budgeted, :activity, :balance).new("Food", 2500, -1200, 1300)
    month = Date.new(2024, 2, 1)

    report = @importer.send(:create, category, month)

    assert_equal month, report.date
    assert_equal 2.5, report.budgeted
    assert_equal 1.2, report.activity
    assert_equal 1.3, report.balance
    assert_equal "Food", report.category.name
  end

  test "#process imports budget data for all months and saves category/report rows" do
    @importer.define_singleton_method(:months) { [ Struct.new(:month).new(Date.new(2024, 1, 1)) ] }
    @importer.define_singleton_method(:categories) { |_month| [ Struct.new(:name, :note, :hidden, :budgeted, :activity, :balance).new("Food", "Groceries", false, 2500, -1200, 1300) ] }

    @importer.process

    category = Category.find_by!(name: "Food")
    report = Report.last

    assert_equal "Groceries", category.note
    assert_equal true, category.visible
    assert_equal 2.5, report.budgeted
    assert_equal 1.2, report.activity
    assert_equal 1.3, report.balance
  end
end
