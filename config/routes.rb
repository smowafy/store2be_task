# frozen_string_literal: true

Rails.application.routes.draw do
  resources :stores do
    resources :spaces
  end
  get '/spaces/:id/price/:start_date/:end_date', to: 'spaces#price_quote'
end
