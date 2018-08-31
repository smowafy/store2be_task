# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_180_831_140_048) do
  create_table 'spaces', force: :cascade do |t|
    t.integer 'store_id'
    t.string 'title', null: false
    t.integer 'size', default: 0
    t.integer 'price_per_day', default: 0
    t.integer 'price_per_week', default: 0
    t.integer 'price_per_month', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['store_id'], name: 'index_spaces_on_store_id'
  end

  create_table 'stores', force: :cascade do |t|
    t.string 'title', null: false
    t.string 'city', null: false
    t.string 'street', null: false
    t.integer 'spaces_count', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
