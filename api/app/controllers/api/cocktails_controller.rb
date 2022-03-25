# frozen_string_literal: true

require 'rest-client'
require 'json'

module Api
  class CocktailsController < ApplicationController
    def index
      if params.key?('category_id') && params.key?('content')
        results = Cocktail.where(category_id: params[:category_id]).where('strDrink like ?', "%#{params['content']}%")
        render json: results, only: %i[id strDrink strDrinkThumb category_id strInstructions]
      elsif params.key?('category_id')
        cocktails = Cocktail.where(category_id: params[:category_id])
        render json: cocktails, only: %i[id strDrink strDrinkThumb category_id strInstructions]
      elsif params.key?('content')
        results = Cocktail.where('strDrink like ?', "%#{params['content']}%")
        render json: results, only: %i[id strDrink strDrinkThumb category_id strInstructions]
      else
        cocktails = Cocktail.order('strDrink')
        render json: cocktails, only: %i[id strDrink strDrinkThumb category_id strInstructions]
      end
    end

    def show
      cocktail = Cocktail.find_by(id: params[:id])
      if cocktail.nil?
        render error: { error: 'Cocktail doesnt exist' }, status: 400
      else
        cocktail_category = Category.find_by(id: cocktail.category_id).strCategory
        render json: { strDrink: cocktail.strDrink, strInstructions: cocktail.strInstructions,
                       strCategory: cocktail_category, strDrinkThumb: cocktail.strDrinkThumb, ingredients: cocktail.ingredients }
      end
    end

    def create
      parameters = cocktail_params

      cocktail = Cocktail.new
      cocktail.strDrink = parameters['strDrink']
      cocktail.strDrinkThumb = parameters['strDrinkThumb']
      cocktail.category_id = parameters['category_id']
      cocktail.strInstructions = parameters['strInstructions']

      parameters['ingredients'].each do |ingredient|
        object_ingredient = Ingredient.find_by('LOWER(strIngredient) = ?', ingredient['strIngredient'].downcase.to_s)

        object_ingredient = Ingredient.create(strIngredient: ingredient['strIngredient']) if object_ingredient.nil?

        cocktail.ingredients.push(object_ingredient)
      end
      if cocktail.save
        render json: cocktail, only: %i[id strDrink strDrinkThumb category_id strInstructions ingredients],
               status: :created
      else
        render error: { error: 'Unable to create Cocktail' }, status: 400
      end
    end

    def update
      parameters = cocktail_params
      puts parameters
      cocktail = Cocktail.find(params[:id])

      if parameters.has_key? :category_id
        cocktail = nil if Category.find(parameters[:category_id]).nil?
      end

      if cocktail.nil?
        render error: { error: 'Unable to update Cocktail' }, status: 400
      else
        cocktail.assign_attributes(cocktail_params.except(:ingredients))
        cocktail.ingredients = []

        parameters['ingredients'].each do |ingredient|
          object_ingredient = Ingredient.find_by('LOWER(strIngredient) = ?', ingredient['strIngredient'].downcase.to_s)

          object_ingredient = Ingredient.create(strIngredient: ingredient['strIngredient']) if object_ingredient.nil?

          cocktail.ingredients.push(object_ingredient)
        end
        if cocktail.save
          render json: cocktail, only: %i[id strDrink strDrinkThumb category_id strInstructions ingredients],
                 status: :ok
        else
          render error: { error: 'Unable to update Cocktail' }, status: 400
        end
      end
    end

    private

    def cocktail_params
      params.require(:cocktail).permit(:strDrink, :strDrinkThumb, :category_id, :strInstructions,
                                       ingredients: [[:strIngredient]])
    end
  end
end
