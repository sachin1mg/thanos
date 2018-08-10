puts 'Material Request Seeder start'

sales_orders = SalesOrder.all
skus = Sku.includes(:batches)
suppliers = Supplier.all
vendors = Vendor.all

sales_orders.each do |sales_order|

  sku = skus.sample
  supplier = suppliers.sample
  vendor = vendors.sample

  mr_po_mapping = MrPoMapping.create!

  material_request = MaterialRequest.create!(
    user: User.first,
    code: Faker::Code.nric,
    delivery_date: rand(1...100).days.from_now,
    vendor: vendor,
    mr_po_mapping: mr_po_mapping,
    sales_order_item_id: sales_order.sales_order_items.first.id,
    quantity: rand(1...100),
    sku: sku,
    schedule_date: rand(1...100).days.from_now
  )

  purchase_order = PurchaseOrder.create!(
    user: User.first,
    supplier: supplier,
    type: [:jit, :bulk].sample,
    code: Faker::Code.nric,
    delivery_date: rand(1...100).days.from_now,
    vendor: vendor
  )

  purchase_receipt = purchase_order.purchase_receipts.create!(
    supplier: supplier,
    code: Faker::Code.nric,
    total_amount: rand(1.0...100.0).round(2),
    vendor: vendor
  )

  purchase_order_item = purchase_order.purchase_order_items.create!(
    sku: sku,
    quantity: rand(1...100),
    price: rand(1.0...100.0).round(2),
    schedule_date: rand(1...100).days.from_now
  )

  mr_po_mapping.update_attributes!(purchase_order_item: purchase_order_item)

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
