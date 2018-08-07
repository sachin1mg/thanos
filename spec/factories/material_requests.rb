FactoryBot.define do
  factory :material_request do
    vendor
    sku
    user
    sales_order_item_ids { [FactoryBot.create(:sales_order_item).id] }
    code { Faker::Lorem.characters(10) }
    quantity { rand(1...10) }
    delivery_date { Faker::Date.between(Date.today, 3.days.from_now) }
    schedule_date { Faker::Date.between(Date.today, 3.days.from_now) }
    status 'draft'
    metadata '{}'
  end
end
