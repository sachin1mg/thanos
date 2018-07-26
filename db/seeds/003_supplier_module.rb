puts 'Seeding supplier module'

Vendor.all.each do |vendor|
  ['quantity', 'flat', 'percent'].each do |discount_type|
    Scheme.create!(vendor: vendor,
                   vendor_type: vendor.types.first,
                   name: Faker::GameOfThrones.character,
                   discount_type: discount_type,
                   discount_units: 10,
                   min_amount_type: discount_type,
                   min_amount: 100)
  end
end
