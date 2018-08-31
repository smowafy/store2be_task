# frozen_string_literal: true

class Space < ApplicationRecord
  include Filterable

  belongs_to :store, counter_cache: true
  validates :title, presence: true
  validates :size, presence: true, numericality: { only_integer: true }
  validates :price_per_day, presence: true, numericality: { only_integer: true }
  validates :price_per_week, presence: true, numericality: { only_integer: true }
  validates :price_per_month, presence: true, numericality: { only_integer: true }

  ATTRIBUTE_MATCHERS = {
    title: %w[eq like],
    size: %w[eq lt gt],
    price_per_day: %w[eq lt gt],
    price_per_week: %w[eq lt gt],
    price_per_month: %w[eq lt gt]
  }.with_indifferent_access

  DURATION_UNITS = [30, 7, 1].freeze

  def price_quote(start_date, end_date)
    starting = start_date.beginning_of_day
    ending = end_date.end_of_day
    total_number_of_seconds = (ending - starting).ceil
    total_number_of_days = total_number_of_seconds / (60 * 60 * 24)

    duration_values = DURATION_UNITS.map do |dur_unit|
      dur_value = total_number_of_days / dur_unit
      total_number_of_days -= dur_unit * dur_value
      dur_value
    end

    months, weeks, days = duration_values

    months * price_per_month + weeks * price_per_week + days * price_per_day
  end
end
