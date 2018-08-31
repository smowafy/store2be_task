# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe SpacesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Space. As you add validations to Space, be sure to
  # adjust the attributes here as well.

  let(:main_store) do
    Store.create! title: 'Store', city: 'City', street: 'Street'
  end

  let(:other_store) do
    Store.create! title: 'Second store', city: 'City', street: 'Street'
  end

  let(:valid_attributes) do
    {
      title: 'Space 1',
      size: 10,
      price_per_day: 120,
      price_per_week: 750,
      price_per_month: 2500,
      store: main_store
    }
  end

  let(:invalid_attributes) do
    {
      title: 'Space 1',
      size: 'string',
      price_per_day: 'another string',
      price_per_week: 123,
      price_per_month: 456,
      store: main_store
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SpacesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    context 'when no filters are provided' do
      before do
        (1..10).each do |number|
          Space.create! title: "Space #{number}",
                        size: 10,
                        price_per_day: 123,
                        price_per_week: 456,
                        price_per_month: 789,
                        store: main_store
          Space.create! title: "Space #{number} dup",
                        size: 10,
                        price_per_day: 123,
                        price_per_week: 456,
                        price_per_month: 789,
                        store: other_store
        end
      end

      let(:expected_response_body) do
        JSON.parse(file_fixture('spaces_controller_get_index_response.json').read)
      end

      it 'returns a success response' do
        get :index, params: { store_id: main_store.id }, session: valid_session
        expect(response).to be_successful
        expect(parsed_response).to eq(expected_response_body)
      end
    end

    context 'when filters are provided' do
      before do
        Space.create!(title: 'first second third',
                      size: 10,
                      price_per_day: 5,
                      price_per_week: 15,
                      price_per_month: 25,
                      store: main_store)

        Space.create!(title: 'second fourth fifth',
                      size: 15,
                      price_per_day: 9,
                      price_per_week: 15,
                      price_per_month: 25,
                      store: main_store)

        Space.create!(title: 'sixth seventh',
                      size: 10,
                      price_per_day: 5,
                      price_per_week: 15,
                      price_per_month: 25,
                      store: main_store)

        Space.create!(title: 'second sixth seventh',
                      size: 8,
                      price_per_day: 5,
                      price_per_week: 15,
                      price_per_month: 25,
                      store: main_store)
      end

      context 'when filters are valid' do
        let(:expected_response_body) do
          [
            {
              title: 'first second third',
              size: 10,
              price_per_day: 5,
              price_per_week: 15,
              price_per_month: 25
            },
            {
              title: 'second fourth fifth',
              size: 15,
              price_per_day: 9,
              price_per_week: 15,
              price_per_month: 25
            }
          ].map(&:with_indifferent_access)
        end

        let(:filter_parameters) do
          {
            title: 'like:second',
            size: 'gt:9',
            store_id: main_store.id
          }
        end

        it 'should return only stores matching filters' do
          get :index, params: filter_parameters, session: valid_session
          expect(response).to be_successful
          expect(parsed_response).to eq(expected_response_body)
        end
      end

      context 'when fitlers are invalid' do
        let(:filter_parameters) do
          {
            title: 'lt:3',
            invalid: 'invalid',
            store_id: main_store.id
          }
        end

        it 'should return a JSON response with error' do
          get :index, params: filter_parameters, session: valid_session
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end
  end

  describe 'GET #show' do
    let(:expected_response_body) do
      { title: 'Space 1', size: 10, price_per_day: 120, price_per_week: 750, price_per_month: 2500 }.with_indifferent_access
    end

    it 'returns a success response' do
      space = Space.create! valid_attributes
      get :show, params: { store_id: main_store.id, id: space.to_param }, session: valid_session
      expect(response).to be_successful
      expect(parsed_response).to eq(expected_response_body)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:create_attributes) do
        {
          title: 'Space 1',
          size: 10,
          price_per_day: 120,
          price_per_week: 750,
          price_per_month: 2500
        }
      end

      let(:expected_response_body) do
        { title: 'Space 1', size: 10, price_per_day: 120, price_per_week: 750, price_per_month: 2500 }.with_indifferent_access
      end

      it 'creates a new Space' do
        expect do
          post :create, params: { store_id: main_store.id, space: create_attributes }, session: valid_session
        end.to change(Space, :count).by(1)
      end

      it 'renders a JSON response with the new space' do
        post :create, params: { store_id: main_store.id, space: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(store_space_url(main_store, Space.last))
        expect(parsed_response).to eq(expected_response_body)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new space' do
        post :create, params: { store_id: main_store.id, space: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          title: 'New space title',
          size: 15
        }
      end

      let(:expected_response_body) do
        { title: 'New space title', size: 15, price_per_day: 120, price_per_week: 750, price_per_month: 2500 }.with_indifferent_access
      end

      it 'updates the requested space' do
        space = Space.create! valid_attributes
        put :update, params: { store_id: main_store.id, id: space.to_param, space: new_attributes }, session: valid_session
        space.reload
        expect(space.title).to eq('New space title')
        expect(space.size).to eq(15)
      end

      it 'renders a JSON response with the space' do
        space = Space.create! valid_attributes

        put :update, params: { store_id: main_store.id, id: space.to_param, space: new_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(parsed_response).to eq(expected_response_body)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the space' do
        space = Space.create! valid_attributes

        put :update, params: { store_id: main_store.id, id: space.to_param, space: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested space' do
      space = Space.create! valid_attributes
      expect do
        delete :destroy, params: { store_id: main_store.id, id: space.to_param }, session: valid_session
      end.to change(Space, :count).by(-1)
    end
  end

  describe 'GET #price_quote' do
    context 'when date is provided as date string' do
      let(:start_date) do
        '2018-07-20 13:20'
      end

      let(:end_date) do
        '2018-07-23 18:05'
      end

      it 'should return correct price' do
        space = Space.create! valid_attributes
        get :price_quote,
            params: { id: space.id, start_date: start_date, end_date: end_date },
            session: valid_session
        expect(response).to be_successful
        expect(parsed_response['price']).to eq(480)
      end
    end

    context 'when date is provided as unix timestamp' do
      let(:start_date) do
        Time.parse('2018-07-20 13:20').to_i
      end

      let(:end_date) do
        Time.parse('2018-07-23 18:05').to_i
      end

      it 'should return correct price' do
        space = Space.create! valid_attributes
        get :price_quote,
            params: { id: space.id, start_date: start_date, end_date: end_date },
            session: valid_session
        expect(response).to be_successful
        expect(parsed_response['price']).to eq(480)
      end
    end

    context 'when date is provided is invalid' do
      let(:start_date) do
        'abc'
      end

      let(:end_date) do
        'efg'
      end

      it 'should fail' do
        space = Space.create! valid_attributes
        get :price_quote,
            params: { id: space.id, start_date: start_date, end_date: end_date },
            session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end