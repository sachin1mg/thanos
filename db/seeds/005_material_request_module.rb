puts 'Material Request Seeder start'

sales_orders = SalesOrder.all
vendor = Vendor.first

sales_orders.each do |sales_order|
  next if [true, false].sample

  sales_order.sales_order_items.each do |so_item|
    material_request = MaterialRequest.find_by(vendor: vendor, sku: so_item.sku, status: :draft)
    material_request ||= MaterialRequest.create!(
                            vendor: vendor,
                            user: vendor.users.sample,
                            sku: so_item.sku,
                            quantity: 0
                         )

    unavailable_quantity = rand(1...so_item.quantity)

    SoiMrMapping.create!(
      sales_order_item: so_item,
      material_request: material_request,
      quantity: unavailable_quantity
    )
    
    material_request.quantity += unavailable_quantity
    material_request.save!
  end
end

puts 'Material Request Seeder end'
