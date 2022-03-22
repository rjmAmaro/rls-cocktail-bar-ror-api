require 'rest-client'
require 'json'

module Api
  class CocktailsController < ApplicationController
    def index
      cocktails = Cocktail.where(category_id: params[:category_id])
      render json: {cocktails: cocktails}
    end

    def list_all
      cocktails = Cocktail.order('name')
      render json: {cocktails: cocktails}
    end

    def show
      cocktail = Cocktail.find_by(id: params[:id])
      if cocktail.nil?
        render json: {cocktail: nil}
      else
        cocktail_category = Category.find_by(id: cocktail.category_id).name
        render json: {name: cocktail.name, desc: cocktail.desc, category: cocktail_category, photo: cocktail.photo, ingredients: cocktail.ingredients}
      end
    end
  end
end