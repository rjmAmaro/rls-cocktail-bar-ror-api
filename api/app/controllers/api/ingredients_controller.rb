module Api
  class IngredientsController < ApplicationController
    def index
=begin
      if params.has_key?(:name)
        ingredients = Ingredient.all? { |ingridient| ingridient.contains?(params["name"]) }
      end
=end
      if params.has_key?("cocktail_id")
        cocktail = Cocktail.find_by(id: params[:cocktail_id])
        render json: cocktail.ingredients, only: [:id, :strIngredient, :strDescription, :strImageSource]
      else
        ingredients = Ingredient.order('strIngredient')
        render json: ingredients, only: [:id, :strIngredient, :strDescription, :strImageSource]
      end
    end

    def search
      if params.has_key?("content")
        results = Ingredient.where("strIngredient like %?%", "#{params["content"]}")
        render json: {ingredients: results}
      else
        render json: {ingredients: nil}
      end
    end

    def show
=begin
      cocktail = Cocktail.find_by(id: params[:cocktail_id])
      count = cocktail.ingredients.count
      i=1
      final_ingredient = nil
      cocktail.ingredients.each do |ingredient|
        if i==params[:id].to_i
          final_ingredient = ingredient
          break
        elsif i>count
          break
        end
        i+=1
      end
      if final_ingredient.nil?
        render json: {ingredient: nil}
      else
        #render json: {name: ingredient.name, decription: ingredient.decription, photo: ingredient.photo}
        render json: {ingredient: final_ingredient}
      end
=end


      ingredient = Ingredient.find_by(id: params[:id])
      if ingredient.nil?
        render json: {ingredient: nil}
      else
        render json: {strIngredient: ingredient.strIngredient, strDescription: ingredient.strDescription, strImageSource: ingredient.strImageSource}
      end
    end
  end
end