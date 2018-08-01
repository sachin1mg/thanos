FactoryBot.define do
  factory :purchase_receipt do
    supplier
    purchase_order
    vendor
    code { Faker::Lorem.characters(10) }
    total_amount { Faker::Number.decimal(3) }
    status 'draft'
    metadata '{}'
  end
end
