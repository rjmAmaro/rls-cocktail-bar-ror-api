# frozen_string_literal: true

require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

describe 'Categories API', type: :request do
  it 'returns all categories' do
    DatabaseCleaner.clean

    Category.create(strCategory: 'Juice')

    get '/api/categories'

    expect(response).to have_http_status(:success)
    expect(response.body).to eq([{ id: 1, strCategory: 'Juice' }].to_json)

    DatabaseCleaner.clean
  end

  it 'returns the correct category' do
    DatabaseCleaner.clean

    Category.create(strCategory: 'Juice')

    get '/api/categories/1'

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json).to eq({ 'id' => 1, 'strCategory' => 'Juice' })

    DatabaseCleaner.clean
  end

  it 'creates a category' do
    DatabaseCleaner.clean

    params = { category: {
      strCategory: 'Juices'
    } }

    first_count = Category.count
    post '/api/categories', params: params
    last_count = Category.count

    expect(response).to have_http_status(:created)
    expect(last_count - first_count).to eq(1)
    expect(response.body).to eq({ id: 1, strCategory: 'Juices' }.to_json)

    DatabaseCleaner.clean
  end

  it 'edit a category' do
    DatabaseCleaner.clean

    Category.create(strCategory: 'Juice_v1')

    params = { category: {
      strCategory: 'Juice_v2'
    } }

    first_count = Category.count
    put '/api/categories/1', params: params
    last_count = Category.count

    expect(response).to have_http_status(:ok)
    expect(last_count - first_count).to eq(0)
    expect(response.body).to eq({ strCategory: 'Juice_v2', id: 1 }.to_json)

    DatabaseCleaner.clean
  end
end
