# Used Faker gem
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 10) }
    password_confirmation { password }
    role { :member }
  end
end
