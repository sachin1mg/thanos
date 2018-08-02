FactoryBot.define do
  factory :material_request do
    vendor
    code { Faker::Lorem.characters(10) }
    delivery_date { Faker::Date.between(Date.today, 3.days.from_now) }
    type :bulk

    trait :jit do
      type :jit
      sales_order
    end
  end
end
