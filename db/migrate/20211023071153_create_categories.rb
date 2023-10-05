# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |table|
      table.string :name
      table.string :note
      table.boolean :visible, default: false, null: false

      table.timestamps
    end
  end
end
