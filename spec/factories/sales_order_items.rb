FactoryBot.define do
  factory :sales_order_item do
    sales_order
    sku
    price { Faker::Number.decimal(3) }
    discount { Faker::Number.decimal(2) }
    quantity { Faker::Number.number(2) }

    trait :with_material_request do
      after :create do |sales_order_item, evaluator|
        vendor = evaluator.sales_order.vendor
        sku = evaluator.sku

        material_request = MaterialRequest.find_by(vendor: vendor, sku: sku)
        material_request ||= MaterialRequest.create!(
          vendor: vendor,
          user: vendor.users.sample || FactoryBot.create(:user, vendor: vendor),
          sku: sku
        )

        FactoryBot.create(:soi_mr_mapping, sales_order_item: sales_order_item, material_request: material_request)
      end
    end
  end
end
