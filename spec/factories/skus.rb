FactoryBot.define do
  factory :sku do
    onemg_sku_id { Faker::IDNumber.valid }
    sku_name { Faker::Name.name }
    manufacturer_name { Faker::Company.name }
    item_group { ['Homeopathy', 'Allopathy'].sample }
    uom { Sku.uoms.map {|k, v| k}.sample }
    pack_size { rand(1...100) }
  end
end
