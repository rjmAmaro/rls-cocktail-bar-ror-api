# frozen_string_literal: true

require 'rest-client'
require 'json'

module Api
  class CategoriesController < ApplicationController
    def index
      categories = Category.order('strCategory')
      render json: categories, only: %i[id strCategory]
    end

    def show
      category = Category.find_by(id: params[:id])
      if category.nil?
        render error: { error: 'Category does not exist' }, status: 400
      else
        render json: category, only: %i[id strCategory]
      end
    end

    def create
      category = Category.new(category_params)
      if category.save
        render json: category, only: %i[id strCategory], status: :created
      else
        render error: { error: 'Unable to create Category' }, status: 400
      end
    end

    def update
      category = Category.find(params[:id])
      if category.nil?
        render error: { error: 'Unable to update Category; Category doesnt exist' }, status: 400
      else
        category.assign_attributes(category_params)
        if category.save
          render json: category, only: %i[id strCategory], status: :ok
        else
          render error: { error: 'Unable to update Category' }, status: 400
        end
      end
    end

    def destroy
      category = Category.find(params[:id])
      category.destroy
      render json: { message: 'Category deleted' }, status: :ok
    end

    private

    def category_params
      params.require(:category).permit('strCategory')
    end
  end
end
