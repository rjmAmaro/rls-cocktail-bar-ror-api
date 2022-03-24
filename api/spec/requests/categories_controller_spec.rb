require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

describe 'Categories API', type: :request do

  it 'returns all categories' do
    DatabaseCleaner.clean

    Category.create(strCategory: "Juice")

    get '/api/categories'

    expect(response).to have_http_status(:success)
    expect(response.body).to eq([{id: 1, strCategory: "Juice"}].to_json)

    DatabaseCleaner.clean
  end

  it 'returns the correct category' do
    DatabaseCleaner.clean

    Category.create(strCategory: "Juice")

    get '/api/categories/1'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq({"id"=>1, "strCategory"=>"Juice"})

    DatabaseCleaner.clean
  end

  it "creates a category" do
    DatabaseCleaner.clean

    params = {category: {
      strCategory: "Juices"
      }
    }

    first_count = Category.count
    post '/api/categories', params: params
    last_count = Category.count

    expect(response).to have_http_status(:created)
    expect(last_count-first_count).to eq(1)
    expect(response.body).to eq({id: 1, strCategory: "Juices"}.to_json)

    DatabaseCleaner.clean
  end

  it "deletes a category" do
    DatabaseCleaner.clean

    Category.create(strCategory: "Juice")

    first_count = Category.count
    delete '/api/categories/1'
    last_count = Category.count

    expect(response).to have_http_status(:ok)
    expect(first_count-last_count).to eq(1)
    expect(response.body).to eq({message: "Category deleted"}.to_json)

    DatabaseCleaner.clean
  end
end