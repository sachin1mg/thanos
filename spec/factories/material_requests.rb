FactoryBot.define do
  factory :material_request do
    user
    sku
    quantity { rand(1...10) }
    downloaded_at { rand(1..3).hours.ago }

    before :create do |material_request, evaluator|
      material_request.vendor = evaluator.user.vendor
    end

    trait :with_purchase_order_item do
      after :create do |material_request, evaluator|
        purchase_order_item = FactoryBot.create(:purchase_order_item,
                                                sku: evaluator.sku,
                                                quantity: evaluator.quantity)
        material_request.update!(purchase_order_item: purchase_order_item)
      end
    end
  end
end
