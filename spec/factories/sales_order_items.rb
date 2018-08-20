FactoryBot.define do
  factory :sales_order_item do
    sales_order
    sku
    price { Faker::Number.decimal(3) }
    discount { Faker::Number.decimal(2) }
    quantity { Faker::Number.number(2) }

    trait :with_material_request do
      after :create do |sales_order_item|
        FactoryBot.create(:soi_mr_mapping, sales_order_item: sales_order_item)
      end
    end
  end
end
