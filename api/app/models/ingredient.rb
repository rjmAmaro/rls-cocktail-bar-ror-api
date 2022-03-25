class Ingredient < ApplicationRecord
  has_and_belongs_to_many :cocktails

  validates :strIngredient, presence: true
end
