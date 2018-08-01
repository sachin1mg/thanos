FactoryBot.define do
  factory :purchase_order do
    supplier
    vendor
    material_request_ids { [FactoryBot.create(:material_request).id, FactoryBot.create(:material_request).id] }
    code { Faker::Lorem.characters(10) }
    delivery_date { Faker::Date.between(Date.today, 3.days.from_now) }
    status 'draft'
    metadata '{}'
  end
end
