# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpacesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/stores/1/spaces').to route_to('spaces#index', store_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/stores/2/spaces/1').to route_to('spaces#show', id: '1', store_id: '2')
    end

    it 'routes to #create' do
      expect(post: '/stores/1/spaces').to route_to('spaces#create', store_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/stores/2/spaces/1').to route_to('spaces#update', id: '1', store_id: '2')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/stores/2/spaces/1').to route_to('spaces#update', id: '1', store_id: '2')
    end

    it 'routes to #destroy' do
      expect(delete: '/stores/2/spaces/1').to route_to('spaces#destroy', id: '1', store_id: '2')
    end
  end
end
