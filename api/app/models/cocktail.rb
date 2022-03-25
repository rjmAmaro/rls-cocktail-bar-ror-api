# frozen_string_literal: true

class Cocktail < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :ingredients

  validates :strDrink, presence: true, uniqueness: true
  validates :category, presence: true
end
