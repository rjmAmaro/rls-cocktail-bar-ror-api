class Category < ApplicationRecord
    has_many :cocktails, dependent: :destroy

    validates :strCategory, presence: true
end
