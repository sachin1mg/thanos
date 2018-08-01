FactoryBot.define do
  factory :material_request_item do
    association :material_request, :bulk
    sku
    quantity { Faker::Number.number(2) }
    schedule_date { Faker::Date.between(Date.today, 3.days.from_now) }
    status 'draft'
    metadata '{}'
  end
end
