# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |table|
      table.references :category, null: false, foreign_key: true
      table.decimal :budgeted, precision: 10, scale: 3
      table.decimal :activity, precision: 10, scale: 3
      table.decimal :balance, precision: 10, scale: 3
      table.date :date

      table.timestamps
    end
  end
end
