FactoryBot.define do
  factory :sales_order_item do
    sales_order
    sku
    price { Faker::Number.decimal(3) }
    discount { Faker::Number.decimal(2) }
    quantity { Faker::Number.number(2) }
  end
end
