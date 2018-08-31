# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  MATCHER_MAPPINGS = {
    like: 'LIKE',
    eq: '=',
    gt: '>',
    lt: '<'
  }.with_indifferent_access

  included do
    const_set('InvalidQuery', Class.new(StandardError))
  end

  class_methods do
    def parse_query(query_string_filters)
      key_diff = query_string_filters.stringify_keys.keys - self::ATTRIBUTE_MATCHERS.keys
      raise self::InvalidQuery, 'invalid keys provided' if key_diff.present?

      unless valid_matchers?(query_string_filters)
        raise self::InvalidQuery, 'invalid matchers provided'
      end

      construct_sql_from_filters(query_string_filters)
    end

    private

    def valid_matchers?(query_string_filters)
      query_string_filters.each do |attr, matcher_and_value|
        matcher_and_value_split = matcher_and_value.split(':')

        return false if matcher_and_value_split.count != 2

        matcher, _value = matcher_and_value_split

        return false unless self::ATTRIBUTE_MATCHERS[attr].include? matcher
      end
      true
    end

    def construct_sql_from_filters(query_string_filters)
      value_arr = []
      query_string = query_string_filters.map do |attr, matcher_and_value|
        matcher_and_value_split = matcher_and_value.split(':')
        matcher, value = matcher_and_value_split
        value_arr << (matcher == 'like' ? "%#{value}%" : value)
        "#{attr} #{MATCHER_MAPPINGS[matcher]} ?"
      end.join(' AND ')
      [query_string] + value_arr
    end
  end
end
