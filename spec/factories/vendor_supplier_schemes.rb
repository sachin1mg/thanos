FactoryBot.define do
  factory :vendor_supplier_scheme do
    vendor_supplier_contract
    sku
    scheme

    trait :active do
      status :active
    end

    trait :inactive do
      status :inactive
    end

    before :create do |vendor_supplier_scheme, evaluator|
      vendor_supplier_scheme.expiry_at = evaluator.scheme.expiry_at
    end
  end
end
