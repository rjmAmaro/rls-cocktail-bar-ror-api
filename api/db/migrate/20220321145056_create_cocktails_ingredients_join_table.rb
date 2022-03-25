# frozen_string_literal: true

class CreateCocktailsIngredientsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :cocktails, :ingredients
  end
end
