# frozen_string_literal: true

require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

describe 'API', type: :request do
  it 'returns all ingredients' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    Cocktail.create(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')
    Ingredient.create(strIngredient: 'Orange', strDescription: 'Its a Fruit!')

    get '/api/ingredients'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([{ 'id' => 1, 'strIngredient' => 'Orange', 'strDescription' => 'Its a Fruit!',
                          'strImageSource' => nil }])

    DatabaseCleaner.clean
  end

  it 'returns an ingredient' do
    DatabaseCleaner.clean

    Ingredient.create(strIngredient: 'Orange', strDescription: 'Its a Fruit!')

    get '/api/ingredients/1'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq({ 'strIngredient' => 'Orange', 'strDescription' => 'Its a Fruit!', 'strImageSource' => nil })

    DatabaseCleaner.clean
  end

  it 'returns ingredients from a cocktail' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    cocktail = Cocktail.new(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')
    ingridient1 = Ingredient.create(strIngredient: 'Orange', strDescription: 'Its a Fruit!')
    ingridient2 = Ingredient.create(strIngredient: 'Water', strDescription: 'h2o')

    cocktail.ingredients.push(ingridient1)
    cocktail.ingredients.push(ingridient2)
    cocktail.save

    get '/api/cocktails/1/ingredients'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([{ 'id' => 1, 'strIngredient' => 'Orange', 'strDescription' => 'Its a Fruit!', 'strImageSource' => nil },
                        { 'id' => 2, 'strIngredient' => 'Water', 'strDescription' => 'h2o', 'strImageSource' => nil }])

    DatabaseCleaner.clean
  end

  it 'returns ingredients from a cocktail' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: 'Juice')
    cocktail = Cocktail.new(strDrink: 'Orange Juice', category: category, strInstructions: 'Put the juice')
    ingridient1 = Ingredient.create(strIngredient: 'Orange', strDescription: 'Its a Fruit!')
    ingridient2 = Ingredient.create(strIngredient: 'Water', strDescription: 'h2o')
    ingridient2 = Ingredient.create(strIngredient: 'Sugar', strDescription: 'Po para as formigas')

    cocktail.ingredients.push(ingridient1)
    cocktail.ingredients.push(ingridient2)
    cocktail.save

    get '/api/ingredients?content=o'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([{ 'id' => 1, 'strIngredient' => 'Orange', 'strDescription' => 'Its a Fruit!',
                          'strImageSource' => nil }])

    DatabaseCleaner.clean
  end

  it 'creates an ingredient' do
    DatabaseCleaner.clean

    params = {
      ingredient: {
        strIngredient: 'Laranja',
        strDescription: 'descricao',
        strImageSource: 'teste_laranja'
      }
    }

    first_count = Ingredient.count
    post '/api/ingredients', params: params
    last_count = Ingredient.count

    expect(response).to have_http_status(:created)
    expect(last_count - first_count).to eq(1)
    expect(response.body).to eq({ id: 1, strIngredient: 'Laranja', strDescription: 'descricao',
                                  strImageSource: 'teste_laranja' }.to_json)

    DatabaseCleaner.clean
  end

  it 'edit an ingredient' do
    DatabaseCleaner.clean

    Ingredient.create(strIngredient: 'Orange', strDescription: 'Its a Fruit!')

    params = {
      ingredient: {
        strDescription: 'descricao da laranja',
        strImageSource: 'teste_laranja_edit'
      }
    }

    first_count = Ingredient.count
    put '/api/ingredients/1', params: params
    last_count = Ingredient.count

    expect(response).to have_http_status(:ok)
    expect(last_count - first_count).to eq(0)
    expect(response.body).to eq({ strDescription: 'descricao da laranja',
                                  strImageSource: 'teste_laranja_edit',
                                  id: 1,
                                  strIngredient: 'Orange'}.to_json)

    DatabaseCleaner.clean
  end
end
