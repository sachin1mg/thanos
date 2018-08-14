FactoryBot.define do
  factory :soi_mr_mapping do
    sales_order_item

    before :create do |soi_mr_mapping, evaluator|
      vendor = evaluator.sales_order_item.sales_order.vendor
      sku = evaluator.sales_order_item.sku

      material_request = MaterialRequest.find_by(vendor: vendor, sku: sku, status: :draft)
      material_request ||= MaterialRequest.create!(
                            vendor: vendor,
                            user: vendor.users.sample || FactoryBot.create(:user, vendor: vendor),
                            sku: sku
                          )

      soi_mr_mapping.material_request = material_request
      soi_mr_mapping.quantity = rand(1...evaluator.sales_order_item.quantity)
    end

    after :create do |soi_mr_mapping, evaluator|
      material_request = evaluator.material_request
      material_request.quantity += soi_mr_mapping.quantity
      material_request.save!
    end
  end
end
