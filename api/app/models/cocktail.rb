class Cocktail < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :ingredients

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true
  validates :desc, presence: true
end
