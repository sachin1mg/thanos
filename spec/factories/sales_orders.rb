FactoryBot.define do
  factory :sales_order do
    vendor
    order_reference_id { Faker::Lorem.characters(10) }
    customer_name { Faker::Name.name }
    amount { Faker::Number.decimal(3) }
    discount { Faker::Number.decimal(2) }
    barcode { Faker::Lorem.characters(10) }
    source { ['1mg', '2mg', '3mg'].sample }
    shipping_label_url { Faker::Internet.url }
    status 'draft'
    metadata '{}'
  end
end
