# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace 'api' do
    resources :categories
    resources :cocktails
    resources :ingredients

    # Routes that are not dependent on other Models Ids
    get '/categories/*category_id/cocktails', to: 'cocktails#index'
    get '/cocktails/*cocktail_id/ingredients', to: 'ingredients#index'
    # get '/ingredients/search/*content', to: 'ingredients#search'
    # get '/cocktails/search/*content', to: 'cocktails#search'
  end
end
