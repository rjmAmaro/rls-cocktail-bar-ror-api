require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

describe 'API', type: :request do

  it 'returns all cocktails' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: "Juice")
    Cocktail.create(strDrink: "Orange Juice", category: category, strInstructions: "Put the juice")

    get '/api/cocktails'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([{"category_id"=>1, "id"=>1, "strDrink"=>"Orange Juice", "strDrinkThumb"=>nil, "strInstructions"=>"Put the juice"}])

    DatabaseCleaner.clean
  end

  it 'returns a cocktail' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: "Juice")
    Cocktail.create(strDrink: "Orange Juice", category: category, strInstructions: "Put the juice")

    get '/api/cocktails/1'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq({"strCategory"=>"Juice", "strDrink"=>"Orange Juice", "strDrinkThumb"=>nil, "strInstructions"=>"Put the juice", "ingredients"=>[]})

    DatabaseCleaner.clean
  end

  it 'returns cocktails from a category' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: "Juice")
    Cocktail.create(strDrink: "Orange Juice", category: category, strInstructions: "Put the juice")
    Cocktail.create(strDrink: "Lemon Juice", category: category, strInstructions: "Put the juice")

    get '/api/categories/1/cocktails'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([{"category_id"=>1, "id"=>1, "strDrink"=>"Orange Juice", "strDrinkThumb"=>nil, "strInstructions"=>"Put the juice"}, {"category_id"=>1, "id"=>2, "strDrink"=>"Lemon Juice", "strDrinkThumb"=>nil, "strInstructions"=>"Put the juice"}]
                    )

    DatabaseCleaner.clean
  end

  it 'search for cocktails' do
    DatabaseCleaner.clean

    category = Category.create(strCategory: "Juice")
    Cocktail.create(strDrink: "Orange Juice", category: category, strInstructions: "Put the juice")
    Cocktail.create(strDrink: "Lemon Juice", category: category, strInstructions: "Put the juice")
    Cocktail.create(strDrink: "Compal de Pera", category: category, strInstructions: "Put the juice")

    get '/api/cocktails?content=ju'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    puts json
    expect(json).to eq([{"category_id"=>1, "id"=>1, "strDrink"=>"Orange Juice", "strDrinkThumb"=>nil, "strInstructions"=>"Put the juice"}, {"category_id"=>1, "id"=>2, "strDrink"=>"Lemon Juice", "strDrinkThumb"=>nil, "strInstructions"=>"Put the juice"}])

    DatabaseCleaner.clean
  end
end