FactoryBot.define do
  factory :inventory_pickup do
    sales_order_item
    inventory
    quantity { Faker::Number.number(2) }
  end
end
