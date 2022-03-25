# frozen_string_literal: true

require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

describe 'Cocktails API', type: :request do
  it 'returns all cocktails' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    Cocktail.create(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')

    get '/api/cocktails'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([{ 'category_id' => 1, 'id' => 1, 'strDrink' => 'Orange Juice', 'strDrinkThumb' => nil,
                          'strInstructions' => 'Put the juice' }])

    DatabaseCleaner.clean
  end

  it 'returns a cocktail' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    Cocktail.create(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')

    get '/api/cocktails/1'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq({ 'strCategory' => 'Juice', 'strDrink' => 'Orange Juice', 'strDrinkThumb' => nil,
                         'strInstructions' => 'Put the juice', 'ingredients' => [] })
    DatabaseCleaner.clean
  end

  it 'returns cocktails from a category' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    Cocktail.create(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')
    Cocktail.create(strDrink: 'Lemon Juice', category: category, strInstructions: 'Put the juice')

    get '/api/categories/1/cocktails'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([
                         { 'category_id' => 1, 'id' => 1, 'strDrink' => 'Orange Juice', 'strDrinkThumb' => nil,
                           'strInstructions' => 'Put the juice' }, { 'category_id' => 1, 'id' => 2, 'strDrink' => 'Lemon Juice', 'strDrinkThumb' => nil, 'strInstructions' => 'Put the juice' }
                       ])

    DatabaseCleaner.clean
  end

  it 'search for cocktails' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    Cocktail.create(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')
    Cocktail.create(strDrink: 'Lemon Juice', category: category, strInstructions: 'Put the juice')
    Cocktail.create(strDrink: 'Compal de Pera', category: category, strInstructions: 'Put the juice')

    get '/api/cocktails?content=ju'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([
                         { 'category_id' => 1, 'id' => 1, 'strDrink' => 'Orange Juice', 'strDrinkThumb' => nil,
                           'strInstructions' => 'Put the juice' }, { 'category_id' => 1, 'id' => 2, 'strDrink' => 'Lemon Juice', 'strDrinkThumb' => nil, 'strInstructions' => 'Put the juice' }
                       ])
    DatabaseCleaner.clean
  end

  it 'creates a cocktail' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')

    params = {
      cocktail: {
        strDrink: 'Ginjinha',
        strDrinkThumb: 'teste_ginjinha',
        category_id: 1,
        strInstructions: 'Bebe e cala',
        ingredients: [{ strIngredient: 'Agua tuga' }]
      }
    }

    first_count = Cocktail.count
    post '/api/cocktails', params: params
    last_count = Cocktail.count
    expect(response).to have_http_status(:created)
    expect(last_count - first_count).to eq(1)
    expect(response.body).to eq({
      "id": 1,
      "strDrink": 'Ginjinha',
      "strDrinkThumb": 'teste_ginjinha',
      "category_id": 1,
      "strInstructions": 'Bebe e cala'
    }.to_json)

    DatabaseCleaner.clean
  end

  it 'edit a cocktail' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice_v1')
    Cocktail.create(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')

    params = {
      cocktail: {
        strInstructions: 'Bebe e cala edit',
        ingredients: [{ strIngredient: 'Agua tuga' }]
      }
    }

    first_count = Cocktail.count
    put '/api/cocktails/1', params: params
    last_count = Cocktail.count

    expect(response).to have_http_status(:ok)
    expect(last_count - first_count).to eq(0)
    expect(response.body).to eq({
      "strInstructions": 'Bebe e cala edit',
      "id": 1,
      "strDrink": 'Orange Juice',
      "strDrinkThumb": nil,
      "category_id": 1
    }.to_json)

    DatabaseCleaner.clean
  end

  it 'deletes a cocktail' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    Cocktail.create(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')

    first_count = Cocktail.count
    delete '/api/cocktails/1'
    last_count = Cocktail.count

    expect(response).to have_http_status(:ok)
    expect(first_count - last_count).to eq(1)
    expect(response.body).to eq({ message: 'Cocktail deleted' }.to_json)

    DatabaseCleaner.clean
  end

  it 'deletes a category and associated cocktail' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    Cocktail.create(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')

    first_count_cocktails = Cocktail.count
    first_count_categories = Category.count
    delete '/api/categories/1'
    last_count_cocktails = Cocktail.count
    last_count_categories = Category.count

    expect(response).to have_http_status(:ok)
    expect(first_count_categories - last_count_categories).to eq(1)
    expect(first_count_cocktails - last_count_cocktails).to eq(1)
    expect(response.body).to eq({ message: 'Category deleted' }.to_json)

    DatabaseCleaner.clean
  end
end
