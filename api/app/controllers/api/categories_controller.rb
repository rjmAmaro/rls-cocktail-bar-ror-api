require 'rest-client'
require 'json'

module Api
  class CategoriesController < ApplicationController
    def index
      #categories = RestClient.get('www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink')
      
      #JSON.parse(categories.body)

      categories = Category.order('strCategory')
      render json: categories, only: [:id, :strCategory]
    end

    def show
      category = Category.find_by(id: params[:id])
      if category.nil?
        render json: {strCategory: nil}
      else
        render json: category, only: [:id, :strCategory]
      end
    end
  end
end