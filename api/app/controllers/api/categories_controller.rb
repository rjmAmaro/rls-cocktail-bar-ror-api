require 'rest-client'
require 'json'

module Api
  class CategoriesController < ApplicationController
    def index
      #categories = RestClient.get('www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink')
      
      #JSON.parse(categories.body)

      categories = Category.order('name')
      render json: {name: categories}
    end

    def show
      category = Category.find_by(id: params[:id])
      if category.nil?
        render json: {category: nil}
      else
        render json: {name: category.name}
      end
    end
  end
end