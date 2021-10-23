class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :note
      t.boolean :visible, default: false

      t.timestamps
    end
  end
end
