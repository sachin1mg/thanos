100.times do
  Vendor.create(
    name: Faker::Name.name,
    status: [:active, :inactive].sample,
    invoice_number_template: ['DD-MM-YYYY-123', 'YYYY-MM-DD-123'].sample
  )
end

100.times do
  Sku.create(
    sku_name: Faker::Name.name,
    manufacturer_name: Faker::Company.name,
    item_group: ['Homeopathy', 'Allopathy'].sample,
    onemg_sku_id: Faker::IDNumber.valid,
    uom: [:number, :ml].sample,
    pack_size: rand(1...100),
  )
end

vendors = Vendor.all

vendors.each do |vendor|
  vendor.locations.create(
    aisle: Faker::Lorem.word,
    rack: Faker::Lorem.word,
    slab: Faker::Lorem.word,
    bin: Faker::Lorem.word
  )
end

skus = Sku.all
locations = Location.all

skus.each do |sku|
  location = locations.sample

  batch = sku.batches.create(
    name: Faker::Lorem.word,
    mrp: rand(1.0...100.0).round(2),
    manufacturing_date: rand(1...100).days.ago,
    expiry_date: rand(1...100).days.from_now
  )

  sku.inventories.create(
    vendor_id: location.vendor_id,
    location_id: location.id,
    batch: batch,
    quantity: rand(1...100),
    blocked_quantity: rand(1...50),
    cost_price: rand(1.0...100.0).round(2),
    selling_price: rand(1.0...100.0).round(2)
  )
end

