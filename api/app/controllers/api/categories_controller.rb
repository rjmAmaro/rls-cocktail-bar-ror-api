require 'rest-client'
require 'json'

module Api
  class CategoriesController < ApplicationController
    def index
      categories = Category.order('strCategory')
      render json: categories, only: [:id, :strCategory]
    end

    def show
      category = Category.find_by(id: params[:id])
      if category.nil?
        render error: { error: 'Category does not exist'}, status: 400
      else
        render json: category, only: [:id, :strCategory]
      end
    end

    def create
      category = Category.new(category_params)
      if(category.save)
        render json: category, only: [:id, :strCategory], status: :created
      else
        render error: { error: 'Unable to create Category'}, status: 400
      end
    end

    def destroy
      category = Category.find(params[:id])
      category.destroy
      render json: {message: 'Category deleted'}, status: :ok
    end

    private
    def category_params
      params.require(:category).permit("strCategory")
    end
  end
end