# frozen_string_literal: true

class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.string :title, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.integer :spaces_count, default: 0

      t.timestamps
    end
  end
end
