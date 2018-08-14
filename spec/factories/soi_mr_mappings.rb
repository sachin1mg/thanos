FactoryBot.define do
  factory :soi_mr_mapping do
    sales_order_item
    material_request

    before :create do |soi_mr_mapping, evaluator|
      soi_mr_mapping.quantity = rand(1...evaluator.sales_order_item.quantity)
    end

    after :create do |soi_mr_mapping, evaluator|
      material_request = evaluator.material_request
      material_request.quantity += soi_mr_mapping.quantity
      material_request.save!
    end
  end
end
