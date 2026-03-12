class Company < ApplicationRecord
    validates :name, presence: true
    validates :schema_name, presence: true, uniqueness: true
end
