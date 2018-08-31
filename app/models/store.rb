# frozen_string_literal: true

class Store < ApplicationRecord
  include Filterable

  has_many :spaces, dependent: :destroy
  validates :title, presence: true
  validates :city, presence: true
  validates :street, presence: true

  ATTRIBUTE_MATCHERS = {
    title: %w[eq like],
    city: %w[eq like],
    street: %w[eq like],
    spaces_count: %w[eq lt gt]
  }.with_indifferent_access
end
