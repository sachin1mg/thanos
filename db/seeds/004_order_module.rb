puts 'Sales Order Seeder start'

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
  SalesOrderItem.create!(
    sales_order: sales_order,
    discount: sales_order.discount * 0.4,
    price: sales_order.amount * 0.4,
    sku: skus.sample
  )

  SalesOrderItem.create!(
    sales_order: sales_order,
    discount: sales_order.discount * 0.6,
    price: sales_order.amount * 0.6,
    sku: skus.sample
  )
end

puts 'Sales Order Item Seeder end'

puts 'Invoices Seeder Start'

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

puts 'Invoices Seeder End'
