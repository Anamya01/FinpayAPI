FactoryBot.define do
  factory :activity_log do
    expense { nil }
    user { nil }
    action { "MyString" }
    metadata { "" }
  end
end
