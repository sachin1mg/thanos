puts 'Seeding supplier module'

20.times do
  Supplier.create(name: Faker::Name.name,
                  status: [:active, :inactive].sample,
                  types: [Faker::GameOfThrones.character, Faker::GameOfThrones.character])
end

Vendor.limit(10).each do |vendor|
  priority = 1
  Supplier.limit(10).each do |supplier|
    VendorSupplierContract.create!(vendor: vendor,
                                   supplier: supplier,
                                   priority: priority)
    priority = rand(2...10)
  end
end

Supplier.limit(10).each do |supplier|
  ['quantity', 'flat', 'percent'].each do |discount_type|
    Scheme.create!(schemable: supplier,
                   name: Faker::GameOfThrones.character,
                   discount_type: discount_type,
                   discount_units: 10,
                   min_amount_type: discount_type,
                   min_amount: 100)
  end

  Sku.limit(10).each do |sku|
    SupplierSku.create!(supplier: supplier, sku: sku, supplier_sku_id: Faker::Number.number(5))
  end
end

VendorSupplierContract.limit(10).each do |vendor_supplier_contract|
  Sku.limit(10).each do |sku|
    Scheme.limit(10).each do |scheme|
      VendorSupplierScheme.create!(vendor_supplier_contract: vendor_supplier_contract, sku: sku, scheme: scheme)
    end
  end
end

puts 'Supplier module seeding done'
