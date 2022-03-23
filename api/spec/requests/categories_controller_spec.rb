require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

describe 'API', type: :request do

  it 'returns all categories' do
    DatabaseCleaner.clean

    Category.create(strCategory: "Juice")

    get '/api/categories'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq([{"id"=>1, "strCategory"=>"Juice"}])

    DatabaseCleaner.clean
  end

  it 'returns a category' do
    DatabaseCleaner.clean

    Category.create(strCategory: "Juice")

    get '/api/categories/1'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq({"id"=>1, "strCategory"=>"Juice"})

    DatabaseCleaner.clean
  end
end