FactoryBot.define do
  factory :supplier_sku do
    supplier
    sku
    supplier_sku_id { Faker::IDNumber.valid }
  end
end
