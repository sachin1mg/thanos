FactoryBot.define do
  factory :inventory do
    location
    batch
    quantity { rand(1...100) }
    blocked_quantity { rand(1...50) }
    cost_price { rand(10.00..500.00).round(2) }
    selling_price { cost_price + rand(10.00..50.00).round(2) }

    before :create do |inventory, evaluator|
      inventory.vendor = evaluator.location.vendor
      inventory.sku = evaluator.batch.sku
    end
  end
end
