class Receipt < ApplicationRecord
  belongs_to :expense
  has_one_attached :file
end
