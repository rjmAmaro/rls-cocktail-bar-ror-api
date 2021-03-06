# frozen_string_literal: true

class CreateCocktails < ActiveRecord::Migration[7.0]
  def change
    create_table :cocktails do |t|
      t.string :strDrink, null: false
      t.string :strDrinkThumb, null: true
      t.references :category, null: false, foreign_key: true
      t.string :strInstructions, null: true

      t.timestamps
    end
  end
end
