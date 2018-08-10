FactoryBot.define do
  factory :supplier do
    name { Faker::Name.name }
    types { [Faker::Lorem.word, Faker::Lorem.word] }

    trait :active do
      status :active
    end

    trait :inactive do
      status :inactive
    end
  end
end
