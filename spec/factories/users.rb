FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    age { rand(121) }
    email { Faker::Internet.unique.email }
  end

  trait :invalid do
    email { nil }
  end
end
