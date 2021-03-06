puts 'Material Request Seeder start.'

sales_orders = SalesOrder.all
vendor = Vendor.first
supplier = Supplier.first

sales_orders.each do |sales_order|
  next if [true, false].sample

  sales_order.sales_order_items.each do |so_item|
    material_request = MaterialRequest.find_by(vendor: vendor, sku: so_item.sku, status: :created)
    material_request ||= MaterialRequest.create!(vendor: vendor,
                                                 user: vendor.users.sample,
                                                 sku: so_item.sku,
                                                 quantity: 0)

    unavailable_quantity = rand(1...so_item.quantity)

    SoiMrMapping.create!(
      sales_order_item: so_item,
      material_request: material_request,
      quantity: unavailable_quantity
    )

    material_request.quantity += unavailable_quantity
    material_request.save!
  end

  sku = sales_order.sales_order_items.first.sku

  material_request = MaterialRequest.create!(
    user: User.first,
    vendor: vendor,
    quantity: rand(1...100),
    sku: sku,
  )

  purchase_order = PurchaseOrder.create!(
    user: User.first,
    supplier: supplier,
    type: [:jit, :bulk].sample,
    code: Faker::Code.nric,
    delivery_date: rand(1...100).days.from_now,
    vendor: vendor
  )

  purchase_receipt = PurchaseReceipt.create!(
    user: User.first,
    supplier: supplier,
    code: Faker::Code.nric,
    total_amount: rand(1.0...100.0).round(2),
    vendor: vendor
  )

  purchase_order_item = purchase_order.purchase_order_items.create!(
    sku: sku,
    material_request: material_request,
    quantity: rand(1...100),
    price: rand(1.0...100.0).round(2),
    schedule_date: rand(1...100).days.from_now
  )

  purchase_receipt.purchase_receipt_items.create!(
    purchase_order_item: purchase_order_item,
    batch: sku.batches.last,
    sku: sku,
    received_quantity: rand(1...100),
    returned_quantity: rand(1...100),
    price: rand(1.0...100.0).round(2),
    schedule_date: rand(1...100).days.from_now
  )
end

puts 'Material Request Seeder end.'
