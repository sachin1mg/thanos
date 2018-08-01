FactoryBot.define do
  factory :material_request do
    vendor
    code { Faker::Lorem.characters(10) }
    delivery_date { Faker::Date.between(Date.today, 3.days.from_now) }
    status 'draft'
    metadata '{}'

    trait :jit do
      type 'jit'
      sales_order
    end
  
    trait :bulk do
      type 'bulk'
    end
  end
end
