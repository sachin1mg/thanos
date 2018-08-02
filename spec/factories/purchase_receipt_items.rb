FactoryBot.define do
  factory :purchase_receipt_item do
    purchase_receipt
    purchase_order_item
    sku
    batch
    received_quantity { Faker::Number.number(2) }
    returned_quantity { Faker::Number.number(2) }
    price { Faker::Number.decimal(3) }
    schedule_date { Faker::Date.between(Date.today, 3.days.from_now) }
  end
end
