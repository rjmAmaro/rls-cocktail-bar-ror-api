class Ingredient < ApplicationRecord
  has_and_belongs_to_many :ingredients

  validates :name, presence: true
  validates :desc, presence: true
end
