FactoryBot.define do
  factory :location do
    vendor
    aisle { Faker::Lorem.word }
    rack { Faker::Lorem.word }
    slab { Faker::Lorem.word }
    bin { Faker::Lorem.word }
  end
end
