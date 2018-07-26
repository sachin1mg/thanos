puts 'Material Request Seeder start'

sales_orders = SalesOrder.all
skus = Sku.includes(:batches)
suppliers = Supplier.all

sales_orders.each do |sales_order|

  material_request = sales_order.create_material_request!(
    code: Faker::Code.nric,
    delivery_date: rand(1...100).days.from_now,
    type: [:jit, :bulk].sample
  )

  sku = skus.sample
  supplier = suppliers.sample

  material_request_item = material_request.material_request_items.create!(
    quantity: rand(1...100),
    sku: sku,
    schedule_date: rand(1...100).days.from_now
  )

  purchase_order = PurchaseOrder.create!(
    supplier: supplier,
    material_request_ids: [material_request.id],
    code: Faker::Code.nric,
    delivery_date: rand(1...100).days.from_now
  )

  purchase_receipt = purchase_order.purchase_receipts.create!(
    supplier: supplier,
    code: Faker::Code.nric,
    total_amount: rand(1.0...100.0).round(2)
  )

  purchase_order_item = purchase_order.purchase_order_items.create!(
    material_request_item: material_request_item,
    sku: sku,
    quantity: rand(1...100),
    price: rand(1.0...100.0).round(2),
    schedule_date: rand(1...100).days.from_now
  )

  purchase_receipt_item = purchase_receipt.purchase_receipt_items.create!(
    purchase_order_item: purchase_order_item,
    batch: sku.batches.last,
    sku: sku,
    received_quantity: rand(1...100),
    returned_quantity: rand(1...100),
    price: rand(1.0...100.0).round(2),
    schedule_date: rand(1...100).days.from_now
  )
end

puts 'Material Request Seeder end'
