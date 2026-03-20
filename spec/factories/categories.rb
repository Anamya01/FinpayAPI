FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{Faker::Commerce.department(max: 1)} #{n} Expenses" }
    description { Faker::Lorem.sentence(word_count: 10) }
  end
end
