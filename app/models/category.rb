class Category < ApplicationRecord
  has_many :expenses
  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }
end
