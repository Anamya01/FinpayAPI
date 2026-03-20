FactoryBot.define do
  factory :activity_log do
    expense
    user
    action { "approved" }
  end
end
