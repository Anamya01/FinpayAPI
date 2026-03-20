FactoryBot.define do
  factory :expense do
    user
    category
    name { "Business Trip" }
    amount { "9.99" }
    description { "Lunch meeting" }
    status { "pending" }
    date { Date.today }
  end
end
