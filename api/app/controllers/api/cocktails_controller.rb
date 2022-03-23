require 'rest-client'
require 'json'

module Api
  class CocktailsController < ApplicationController
    def index
      if params.has_key?("category_id")
        cocktails = Cocktail.where(category_id: params[:category_id])
        render json: cocktails, only: [:id, :strDrink, :strDrinkThumb, :category_id, :strInstructions]
      else
        cocktails = Cocktail.order('strDrink')
        render json: cocktails, only: [:id, :strDrink, :strDrinkThumb, :category_id, :strInstructions]
      end
    end

    def search
      if params.has_key?("content")
        results = Cocktail.where("strDrink like ?", "%#{params["content"]}%")
        render json: {drinks: results}
      else
        render json: {drinks: nil}
      end
    end

    def show
      cocktail = Cocktail.find_by(id: params[:id])
      if cocktail.nil?
        render json: {drinks: nil}
      else
        cocktail_category = Category.find_by(id: cocktail.category_id).strCategory
        render json: {strDrink: cocktail.strDrink, strInstructions: cocktail.strInstructions, strCategory: cocktail_category, strDrinkThumb: cocktail.strDrinkThumb, ingredients: cocktail.ingredients}
      end
    end
  end
end