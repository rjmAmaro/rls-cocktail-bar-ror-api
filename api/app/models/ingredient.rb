class Ingredient < ApplicationRecord
  has_and_belongs_to_many :ingredients

  validates :strIngredient, presence: true
end
