FactoryBot.define do
  factory :vendor_supplier_contract do
    vendor
    supplier

    trait :active do
      status :active
    end

    trait :inactive do
      status :inactive
    end

    before :create do |contract, evaluator|
      highest_priority_contract = VendorSupplierContract.find_by(priority: 1, vendor: evaluator.vendor)
      contract.priority = highest_priority_contract.present? ? rand(2...10) : 1
    end
  end
end
