FactoryBot.define do
  factory :purchase_order do
    supplier
    vendor
    user
    po_type { %w[jit bulk].sample }
    code { Faker::Lorem.characters(10) }
    delivery_date { Faker::Date.between(Date.today, 3.days.from_now) }
    status 'draft'
    metadata '{}'
  end
end
