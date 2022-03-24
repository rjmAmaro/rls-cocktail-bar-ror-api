require 'rest-client'
require 'json'

module Api
  class CocktailsController < ApplicationController
    def index
      if params.has_key?("category_id") && params.has_key?("content")
        results = Cocktail.where(category_id: params[:category_id]).where("strDrink like ?", "%#{params["content"]}%")
        render json: results, only: [:id, :strDrink, :strDrinkThumb, :category_id, :strInstructions]
      elsif params.has_key?("category_id")
        cocktails = Cocktail.where(category_id: params[:category_id])
        render json: cocktails, only: [:id, :strDrink, :strDrinkThumb, :category_id, :strInstructions]
      elsif params.has_key?("content")
        results = Cocktail.where("strDrink like ?", "%#{params["content"]}%")
        render json: results, only: [:id, :strDrink, :strDrinkThumb, :category_id, :strInstructions]
      else
        cocktails = Cocktail.order('strDrink')
        render json: cocktails, only: [:id, :strDrink, :strDrinkThumb, :category_id, :strInstructions]
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


    def create
      parameters = cocktail_params

      cocktail = Cocktail.new
      cocktail.strDrink = parameters["strDrink"]
      cocktail.strDrinkThumb = parameters["strDrinkThumb"]
      cocktail.category_id = parameters["category_id"]
      cocktail.strInstructions = parameters["strInstructions"]

      for ingredient in parameters["ingredients"]
        object_ingredient = Ingredient.find_by("LOWER(strIngredient) = ?", "#{ingredient["strIngredient"].downcase}")

        if object_ingredient.nil?
          object_ingredient = Ingredient.create(strIngredient: ingredient["strIngredient"])
        end

        cocktail.ingredients.push(object_ingredient)
      end
      if(cocktail.save)
        render json: cocktail, only: [:id, :strDrink, :strDrinkThumb, :category_id, :strInstructions], status: :created
      else
        render error: { error: 'Unable to create Cocktail'}, status: 400
      end
    end

    private
    def cocktail_params
      params.require(:cocktail).permit(:strDrink,:strDrinkThumb,:category_id,:strInstructions,ingredients:[[:strIngredient]])
    end
  end
end