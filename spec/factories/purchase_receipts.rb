FactoryBot.define do
  factory :purchase_receipt do
    supplier
    vendor
    user
    code { Faker::Lorem.characters(10) }
    total_amount { Faker::Number.decimal(3) }
  end
end
