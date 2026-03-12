class Company < ApplicationRecord
    validates :name, presence: true
    validates :subdomain, presence: true, uniqueness: { case_sensitive: false }
end
