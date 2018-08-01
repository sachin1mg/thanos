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

    before :create do |vendor_supplier_scheme|
      vendor_supplier_scheme.expiry_at = vendor_supplier_scheme.scheme.expiry_at
    end
  end
end
