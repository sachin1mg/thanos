FactoryBot.define do
  factory :purchase_order_item do
    purchase_order
    sku
    material_request
    quantity { Faker::Number.number(2) }
    price { Faker::Number.decimal(2) }
    schedule_date { Faker::Date.between(Date.today, 3.days.from_now) }
  end
end
