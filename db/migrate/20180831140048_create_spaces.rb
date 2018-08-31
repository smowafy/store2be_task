# frozen_string_literal: true

class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces do |t|
      t.references :store, foreign_key: true
      t.string :title, null: false
      t.integer :size, default: 0
      t.integer :price_per_day, default: 0
      t.integer :price_per_week, default: 0
      t.integer :price_per_month, default: 0

      t.timestamps
    end
  end
end
