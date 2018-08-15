puts 'Sales Order Seeder start.'

vendors = Vendor.all
skus = Sku.all

100.times do
  amount = Faker::Number.decimal(2).to_f
  SalesOrder.create!(vendor: vendors.sample,
                     order_reference_id: Faker::Lorem.characters(10),
                     customer_name: Faker::GameOfThrones.character,
                     discount: rand(0.0...amount),
                     amount: amount)
end

puts 'Sales Order Seeder end'


puts 'Sales Order Item Seeder start'

SalesOrder.all.each do |sales_order|
  item1 = SalesOrderItem.create!(
    sales_order: sales_order,
    discount: sales_order.discount * 0.4,
    quantity: rand(3...10),
    price: sales_order.amount * 0.4,
    sku: skus.sample
  )

  InventoryPickup.create!(
    sales_order_item: item1,
    inventory: item1.sku.inventories.sample,
    quantity: rand(1..item1.quantity)
  )

  item2 = SalesOrderItem.create!(
    sales_order: sales_order,
    discount: sales_order.discount * 0.6,
    price: sales_order.amount * 0.6,
    quantity: rand(3...10),
    sku: skus.sample
  )

  InventoryPickup.create!(
    sales_order_item: item2,
    inventory: item2.sku.inventories.sample,
    quantity: rand(1..item2.quantity)
  )
end

puts 'Sales Order Item Seeder end.'

puts 'Invoices Seeder start.'

SalesOrder.all.each do |sales_order|
  [1, 2].sample.times do |n|
    Invoice.create!(
      sales_order: sales_order,
      number: "INV-#{sales_order.id}-#{n + 1}",
      date: Date.today,
      attachment_file_name: Faker::File.file_name(nil, nil, 'pdf'),
      attachment_content_type: 'application/pdf',
      attachment_file_size: rand(0...1000),
      attachment_updated_at: Time.zone.now
    )
  end
end

puts 'Invoices Seeder end.'
