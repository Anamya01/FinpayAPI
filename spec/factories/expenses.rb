FactoryBot.define do
  factory :expense do
    user
    category
    name { Faker::Commerce.product_name }
    amount { 9.99 }
    description { Faker::Lorem.sentence(word_count: 10) }
    date { Date.today }

    trait :with_receipts do
      after(:create) do |expense|
        expense.receipts.attach(
          io: File.open(Rails.root.join('spec/fixtures/files/test.jpg')),
          filename: 'test.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
