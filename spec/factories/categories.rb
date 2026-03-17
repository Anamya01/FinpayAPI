FactoryBot.define do
  factory :category do
    name { Faker::Commerce.unique.department(max: 1) + " Expenses" }
    description { Faker::Lorem.sentence(word_count: 10) }
  end
end
