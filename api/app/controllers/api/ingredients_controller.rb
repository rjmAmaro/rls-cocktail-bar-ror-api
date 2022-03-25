module Api
  class IngredientsController < ApplicationController
    def index
      if params.has_key?("cocktail_id") && params.has_key?("content")
        cocktail = Cocktail.find_by(id: params[:cocktail_id])
        results = cocktail.ingredients.where("strIngredient like ?", "%#{params["content"]}%")
        render json: results, only: [:id, :strIngredient, :strDescription, :strImageSource]
      elsif params.has_key?("cocktail_id")
        cocktail = Cocktail.find_by(id: params[:cocktail_id])
        render json: cocktail.ingredients, only: [:id, :strIngredient, :strDescription, :strImageSource]
      elsif params.has_key?("content")
        results = Ingredient.where("strIngredient like ?", "%#{params["content"]}%")
        render json: results, only: [:id, :strIngredient, :strDescription, :strImageSource]
      else
        ingredients = Ingredient.order('strIngredient')
        render json: ingredients, only: [:id, :strIngredient, :strDescription, :strImageSource]
      end
    end

    def show
      ingredient = Ingredient.find_by(id: params[:id])
      if ingredient.nil?
        render error: { error: 'Ingredient does not exist'}, status: 400
      else
        render json: {strIngredient: ingredient.strIngredient, strDescription: ingredient.strDescription, strImageSource: ingredient.strImageSource}
      end
    end

    def create
      ingredient = Ingredient.new(ingredient_params)
      if ingredient.save
        render json: ingredient, only: [:id, :strIngredient, :strDescription, :strImageSource], status: :created
      else
        render error: { error: 'Unable to create Ingredient'}, status: 400
      end
    end

    def destroy
      ingredient = Ingredient.find(params[:id])
      ingredient.destroy
      render json: {message: 'Ingredient deleted'}, status: :ok
    end

    private
    def ingredient_params
      params.require(:ingredient).permit("strIngredient","strDescription","strImageSource")
    end
  end
end