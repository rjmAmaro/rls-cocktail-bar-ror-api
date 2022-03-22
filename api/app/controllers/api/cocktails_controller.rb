require 'rest-client'
require 'json'

module Api
  class CocktailsController < ApplicationController
    def index
      categories = RestClient.get('www.thecocktaildb.com/api/json/v1/1/list.php?c=list')
      #@categories = Category.order('created_at DESC');
      #JSON.parse(categories.body)
      render json: categories
    end
  end
end