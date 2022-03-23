module Api
  class IngredientsController < ApplicationController
    def index
=begin
      if params.has_key?(:name)
        ingredients = Ingredient.all? { |ingridient| ingridient.contains?(params["name"]) }
      end
=end
      cocktail = Cocktail.find_by(id: params[:cocktail_id])
      render json: {ingredients: cocktail.ingredients}
    end

    def list_all
      ingredients = Ingredient.order('name')
      render json: {ingredients: ingredients}
    end

    def show
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
        #render json: {name: ingredient.name, desc: ingredient.desc, photo: ingredient.photo}
        render json: {ingredient: final_ingredient}
      end

=begin
      ingredient = Ingredient.find_by(id: params[:id])
      if ingredient.nil?
        render json: {ingredient: nil}
      else
        render json: {name: ingredient.name, desc: ingredient.desc, photo: ingredient.photo}
      end
=end
    end
  end
end