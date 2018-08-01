FactoryBot.define do
  factory :scheme do
    association :schemable, factory: :supplier
    name { Faker::Name.name }
    discount_type { ['quantity', 'flat', 'percent'].sample }
    discount_units { rand(1...10) }
    min_amount { rand(100...200) }
    min_amount_type { discount_type }
    expiry_at { rand(20...100).days.from_now }

    trait :active do
      status :active
    end

    trait :inactive do
      status :inactive
    end
  end
end
