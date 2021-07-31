FactoryBot.define do
  factory :message do
    user
    title { Faker::Lorem.word }
    content { Faker::Lorem.paragraph }
  end
end
