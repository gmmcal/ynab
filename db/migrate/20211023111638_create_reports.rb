class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :category, null: false, foreign_key: true
      t.decimal :budgeted, precision: 10, scale: 3
      t.decimal :activity, precision: 10, scale: 3
      t.decimal :balance, precision: 10, scale: 3
      t.date :date

      t.timestamps
    end
  end
end
