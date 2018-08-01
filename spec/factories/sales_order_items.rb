FactoryBot.define do
  factory :sales_order_item do
    sales_order
    sku
    price { Faker::Number.decimal(3) }
    discount { Faker::Number.decimal(2) }
    quantity { Faker::Number.number(2) }
    shipping_label_url { Faker::Internet.url }
    status 'draft'
    metadata '{}'
  end
end
