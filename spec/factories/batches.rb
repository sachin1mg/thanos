FactoryBot.define do
  factory :batch do
    sku
    name { Faker::Lorem.word }
    mrp { rand(1.0...100.0).round(2) }
    manufacturing_date { rand(1...100).days.ago }
    expiry_date { rand(1...100).days.from_now }
  end
end
