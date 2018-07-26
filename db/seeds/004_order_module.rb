puts 'Sales Order Seeder start'

100.times do
  amount = Faker::Number.decimal(2).to_f
  SalesOrder.create!(discount: rand(0.0...amount),
                     amount: amount)
end

puts 'Sales Order Seeder start'


puts 'Sales Order Item Seeder start'

SalesOrder.all.each do |sales_order|
  SalesOrderItem.create!(sales_order: sales_order,
                         discount: sales_order.discount * 0.4,
                         price: sales_order.amount * 0.4)

  SalesOrderItem.create!(sales_order: sales_order,
                         discount: sales_order.discount * 0.6,
                         price: sales_order.amount * 0.6)
end

puts 'Sales Order Item Seeder start'

