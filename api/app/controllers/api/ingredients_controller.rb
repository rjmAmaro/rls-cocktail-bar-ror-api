module Api
  class IngredientsController < ApplicationController
    def index
      ingredients = Ingredient.order('name')
      render json: {ingredients: ingredients}
    end

    def show
      ingredient = Ingredient.find_by(id: params[:id])
      if ingredient.nil?
        render json: {ingredient: nil}
      else
        render json: {name: ingredient.name, desc: ingredient.desc, photo: ingredient.photo}
      end
    end
  end
end