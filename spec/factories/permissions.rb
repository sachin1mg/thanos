FactoryBot.define do
  factory :permission do
    label { Faker::Zelda.unique.item }

    trait :active do
      status :active
    end

    trait :inactive do
      status :inactive
    end
  end
end
