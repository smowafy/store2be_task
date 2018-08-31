# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Space, type: :model do
  describe '#self.parse_query' do
    context 'when invalid parameters are provided' do
      let(:input_hash) do
        {
          title: 'like:abc',
          invalid: 'eq:3'
        }
      end

      it 'should throw an error' do
        expect { Space.parse_query(input_hash) }.to raise_error(Space::InvalidQuery)
      end
    end

    context 'when valid parameters but invalid matchers are provided' do
      let(:input_hash) do
        {
          title: 'like:abc',
          size: 'lt:3',
          price_per_week: 'like:random'
        }
      end

      it 'should throw an error' do
        expect { Space.parse_query(input_hash) }.to raise_error(Space::InvalidQuery)
      end
    end

    context 'when valid params and valid matchers are provided' do
      let(:input_hash) do
        {
          title: 'like:abc',
          size: 'eq:4',
          price_per_day: 'lt:5'
        }
      end

      let(:expected_return_value) do
        ['title LIKE ? AND size = ? AND price_per_day < ?', '%abc%', '4', '5']
      end

      it 'should return the expected query' do
        return_value = Space.parse_query(input_hash)
        expect(return_value).to eq(expected_return_value)
      end
    end
  end

  describe '#price_quote' do
    let(:valid_parameters) do
      store = Store.create!(title: 'Store 1', city: 'City 1', street: 'Street 1')

      {
        title: 'Space 1',
        size: 10,
        price_per_day: 100,
        price_per_week: 500,
        price_per_month: 2350,
        store: store
      }
    end

    context 'for 42 days' do
      let(:end_date) do
        Time.now
      end

      let(:start_date) do
        42.days.until(end_date)
      end

      let(:expected_value) do
        3450
      end

      it 'should return the correct value for quote' do
        space = Space.create! valid_parameters
        expect(space.price_quote(start_date, end_date)).to eq(expected_value)
      end
    end

    context 'mid day to mid next day' do
      let(:start_date) do
        Time.parse('2018-08-01 15:35:00')
      end
      let(:end_date) do
        1.day.since(start_date)
      end

      let(:expected_value) do
        200
      end

      it 'should have the price of 2 days' do
        space = Space.create! valid_parameters
        expect(space.price_quote(start_date, end_date)).to eq(expected_value)
      end
    end
  end
end
