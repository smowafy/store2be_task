# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  describe '#self.parse_query' do
    context 'when invalid parameters are provided' do
      let(:input_hash) do
        {
          title: 'like:abc',
          invalid: 'eq:3'
        }
      end

      it 'should throw an error' do
        expect { Store.parse_query(input_hash) }.to raise_error(Store::InvalidQuery)
      end
    end

    context 'when valid parameters but invalid matchers are provided' do
      let(:input_hash) do
        {
          title: 'like:abc',
          city: 'lt:3',
          spaces_count: 'like:random'
        }
      end

      it 'should throw an error' do
        expect { Store.parse_query(input_hash) }.to raise_error(Store::InvalidQuery)
      end
    end

    context 'when valid params and valid matchers are provided' do
      let(:input_hash) do
        {
          title: 'like:abc',
          city: 'like:def',
          street: 'eq:ghi',
          spaces_count: 'gt:4'
        }
      end

      let(:expected_return_value) do
        ['title LIKE ? AND city LIKE ? AND street = ? AND spaces_count > ?', '%abc%', '%def%', 'ghi', '4']
      end

      it 'should return the expected query' do
        return_value = Store.parse_query(input_hash)
        expect(return_value).to eq(expected_return_value)
      end
    end
  end
end
